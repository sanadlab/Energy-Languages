// Generic C# loop-harness for the cross-language transfer check.
// Reads the SAME shared JSON inputs as the Python/Java harnesses, marshals each
// value into the Solution method's typed parameters via reflection, and loops the
// call to a wall-time budget (checksum-consumed, iteration-counted). Reflection
// makes the call opaque to the JIT, so it cannot hoist/eliminate the loop body.
//
//   dotnet exec csbench.dll <budget_seconds> <case_index>   (run from the cell dir)
//   - slug derived from the cell directory name (CSharp/leetcode/<slug>/)
//   - inputs from ../../../reference/leetcode/{outputs,workloads}/<slug>.json
//   - prints CASE/ITERS/ACC/BEACON to STDERR (stdout stays empty -> validate ok)
// Handles plain-data, TreeNode/ListNode (constructed from serialized input), and
// design classes (input {ops,args} -> constructor + method replay). Compiled
// together with the cell's solution.cs into the single "csbench" assembly.

using System.Diagnostics;
using System.Globalization;
using System.Numerics;
using System.Reflection;
// ImplicitUsings supplies System, System.Collections.Generic, System.IO, System.Linq.

public class TreeNode {
    public int val;
    public TreeNode left;
    public TreeNode right;
    public TreeNode(int v = 0, TreeNode l = null, TreeNode r = null) { val = v; left = l; right = r; }
}
public class ListNode {
    public int val;
    public ListNode next;
    public ListNode(int v = 0, ListNode n = null) { val = v; next = n; }
}

// Insertion-ordered map (JSON object) — preserves argument order and allows key lookup.
class OMap {
    public List<string> Keys = new();
    public List<object> Vals = new();
    public void Add(string k, object v) { Keys.Add(k); Vals.Add(v); }
    public bool Has(string k) => Keys.Contains(k);
    public object Get(string k) { int i = Keys.IndexOf(k); return i < 0 ? null : Vals[i]; }
}

public static class Harness {
    // ---------- minimal JSON parser ----------
    static string S; static int P;
    static object Parse(string t) { S = t; P = 0; Ws(); return Val(); }
    static void Ws() { while (P < S.Length && char.IsWhiteSpace(S[P])) P++; }
    static object Val() {
        Ws(); char c = S[P];
        if (c == '{') return Obj();
        if (c == '[') return Arr();
        if (c == '"') return Str();
        if (c == 't') { P += 4; return true; }
        if (c == 'f') { P += 5; return false; }
        if (c == 'n') { P += 4; return null; }
        return Num();
    }
    static OMap Obj() {
        var m = new OMap(); P++; Ws();
        if (S[P] == '}') { P++; return m; }
        while (true) {
            Ws(); string k = Str(); Ws(); P++; object v = Val(); m.Add(k, v); Ws();
            if (S[P] == ',') { P++; continue; }
            P++; break;
        }
        return m;
    }
    static List<object> Arr() {
        var a = new List<object>(); P++; Ws();
        if (S[P] == ']') { P++; return a; }
        while (true) {
            a.Add(Val()); Ws();
            if (S[P] == ',') { P++; continue; }
            P++; break;
        }
        return a;
    }
    static string Str() {
        var b = new System.Text.StringBuilder(); P++;
        while (true) {
            char c = S[P++]; if (c == '"') break;
            if (c == '\\') {
                char e = S[P++];
                switch (e) {
                    case 'n': b.Append('\n'); break;
                    case 't': b.Append('\t'); break;
                    case 'r': b.Append('\r'); break;
                    case '"': b.Append('"'); break;
                    case '\\': b.Append('\\'); break;
                    case '/': b.Append('/'); break;
                    case 'b': b.Append('\b'); break;
                    case 'f': b.Append('\f'); break;
                    case 'u': b.Append((char)int.Parse(S.Substring(P, 4), NumberStyles.HexNumber)); P += 4; break;
                    default: b.Append(e); break;
                }
            } else b.Append(c);
        }
        return b.ToString();
    }
    static object Num() {
        int st = P; bool dbl = false;
        while (P < S.Length) {
            char c = S[P];
            if (c == '-' || c == '+' || (c >= '0' && c <= '9')) P++;
            else if (c == '.' || c == 'e' || c == 'E') { dbl = true; P++; }
            else break;
        }
        string t = S.Substring(st, P - st);
        if (dbl) return double.Parse(t, CultureInfo.InvariantCulture);
        if (long.TryParse(t, out long l)) return l;
        return BigInteger.Parse(t);
    }

    // ---------- numeric coercion ----------
    static long ToLong(object v) {
        if (v is long l) return l;
        if (v is int i) return i;
        if (v is double d) return (long)d;
        if (v is BigInteger bi) return (long)bi;
        return long.Parse(Convert.ToString(v, CultureInfo.InvariantCulture));
    }
    static double ToDouble(object v) {
        if (v is double d) return d;
        if (v is long l) return l;
        if (v is int i) return i;
        if (v is BigInteger bi) return (double)bi;
        return double.Parse(Convert.ToString(v, CultureInfo.InvariantCulture));
    }

    // ---------- marshal parsed JSON -> typed C# argument ----------
    static object Marshal(Type t, object v) {
        if (t == typeof(int)) return (int)ToLong(v);
        if (t == typeof(long)) return ToLong(v);
        if (t == typeof(short)) return (short)ToLong(v);
        if (t == typeof(byte)) return (byte)ToLong(v);
        if (t == typeof(double)) return ToDouble(v);
        if (t == typeof(float)) return (float)ToDouble(v);
        if (t == typeof(bool)) return (bool)v;
        if (t == typeof(char)) return ((string)v)[0];
        if (t == typeof(string)) return (string)v;
        if (t == typeof(object)) return v;
        if (t == typeof(TreeNode)) return BuildTree((List<object>)v);
        if (t == typeof(ListNode)) return BuildList((List<object>)v);
        if (t.IsArray) {
            Type elem = t.GetElementType();
            if (elem == typeof(char) && v is string sv) return sv.ToCharArray();
            var list = (List<object>)v;
            var arr = Array.CreateInstance(elem, list.Count);
            for (int i = 0; i < list.Count; i++) arr.SetValue(Marshal(elem, list[i]), i);
            return arr;
        }
        if (t.IsGenericType) {
            Type elem = t.GetGenericArguments()[0];
            var list = (List<object>)v;
            var listType = typeof(List<>).MakeGenericType(elem);
            var res = (System.Collections.IList)Activator.CreateInstance(listType);
            foreach (var o in list) res.Add(Marshal(elem, o));
            return res;
        }
        throw new Exception("unhandled type " + t);
    }

    static TreeNode BuildTree(List<object> l) {
        if (l == null || l.Count == 0 || l[0] == null) return null;
        var root = new TreeNode((int)ToLong(l[0]));
        var q = new Queue<TreeNode>(); q.Enqueue(root); int i = 1;
        while (i < l.Count && q.Count > 0) {
            var n = q.Dequeue();
            if (i < l.Count) { var lv = l[i++]; if (lv != null) { n.left = new TreeNode((int)ToLong(lv)); q.Enqueue(n.left); } }
            if (i < l.Count) { var rv = l[i++]; if (rv != null) { n.right = new TreeNode((int)ToLong(rv)); q.Enqueue(n.right); } }
        }
        return root;
    }
    static ListNode BuildList(List<object> l) {
        if (l == null || l.Count == 0) return null;
        var head = new ListNode((int)ToLong(l[0])); var cur = head;
        for (int i = 1; i < l.Count; i++) { cur.next = new ListNode((int)ToLong(l[i])); cur = cur.next; }
        return head;
    }

    // ---------- deep clone args each iteration (mutation safety) ----------
    static object Clone(object o) {
        if (o == null) return null;
        if (o is string) return o;                       // immutable
        if (o is TreeNode t) return CloneTree(t);
        if (o is ListNode ln) return CloneList(ln);
        if (o is Array a) {
            Type elem = o.GetType().GetElementType();
            var b = Array.CreateInstance(elem, a.Length);
            for (int i = 0; i < a.Length; i++) {
                var e = a.GetValue(i);
                b.SetValue((elem.IsArray || e is TreeNode || e is ListNode || e is System.Collections.IList) ? Clone(e) : e, i);
            }
            return b;
        }
        if (o is System.Collections.IList il) {
            var res = (System.Collections.IList)Activator.CreateInstance(o.GetType());
            foreach (var e in il) res.Add(Clone(e));
            return res;
        }
        return o;                                        // boxed value types are immutable
    }
    static TreeNode CloneTree(TreeNode n) { if (n == null) return null; return new TreeNode(n.val, CloneTree(n.left), CloneTree(n.right)); }
    static ListNode CloneList(ListNode n) { if (n == null) return null; var h = new ListNode(n.val); var c = h; n = n.next; while (n != null) { c.next = new ListNode(n.val); c = c.next; n = n.next; } return h; }
    static object[] CloneAll(object[] a) { var b = new object[a.Length]; for (int i = 0; i < a.Length; i++) b[i] = Clone(a[i]); return b; }
    // structural snapshot of the argument tuple (Canon recurses into every array/list, so an in-place mutation shows up)
    static string Snap(object[] a) { var b = new System.Text.StringBuilder(); foreach (var o in a) { b.Append(Canon(o)); b.Append('\u0001'); } return b.ToString(); }

    // ---------- canonical string of a result (order-preserving) ----------
    static string Canon(object r) {
        if (r == null) return "null";
        if (r is string s) return s;
        if (r is bool b) return b ? "true" : "false";
        if (r is char ch) return ch.ToString();
        if (r is TreeNode t) return Canon(TreeToArr(t));
        if (r is ListNode ln) return Canon(ListToArr(ln));
        if (r is double d) return d.ToString("R", CultureInfo.InvariantCulture);
        if (r is float f) return ((double)f).ToString("R", CultureInfo.InvariantCulture);
        if (r is System.Collections.IEnumerable en) {
            var parts = new List<string>();
            foreach (var e in en) parts.Add(Canon(e));
            return "[" + string.Join(", ", parts) + "]";
        }
        return Convert.ToString(r, CultureInfo.InvariantCulture);
    }
    static List<object> ListToArr(ListNode h) { var a = new List<object>(); while (h != null) { a.Add((long)h.val); h = h.next; } return a; }
    static List<object> TreeToArr(TreeNode r) {
        var a = new List<object>(); var q = new Queue<TreeNode>(); q.Enqueue(r);
        while (q.Count > 0) { var n = q.Dequeue(); if (n == null) a.Add(null); else { a.Add((long)n.val); q.Enqueue(n.left); q.Enqueue(n.right); } }
        while (a.Count > 0 && a[a.Count - 1] == null) a.RemoveAt(a.Count - 1);
        return a;
    }

    // ---------- checksum fold (stable, DCE-defeating) ----------
    static long HashStr(string s) { long h = 0; unchecked { foreach (char c in s) h = h * 31 + c; } return h; }
    static long Fold(long acc, object r) { unchecked { return acc * 1000003 + HashStr(Canon(r)); } }

    // ---------- type lookup within the single compiled assembly ----------
    static Type FindType(string name) {
        var t = Type.GetType(name);
        if (t != null) return t;
        foreach (var asm in AppDomain.CurrentDomain.GetAssemblies()) {
            t = asm.GetType(name);
            if (t != null) return t;
        }
        return null;
    }
    const BindingFlags PUB = BindingFlags.Public | BindingFlags.Instance | BindingFlags.DeclaredOnly;
    const BindingFlags ANY = BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance | BindingFlags.DeclaredOnly;

    // ---------- design-class replay: ctor + method sequence ----------
    static long Replay(Type dc, List<object> ops, List<object> args) {
        var ctorArgs = (List<object>)args[0];
        var ctor = dc.GetConstructors().First(ct => ct.GetParameters().Length == ctorArgs.Count);
        var cpt = ctor.GetParameters();
        var ca = new object[cpt.Length];
        for (int i = 0; i < ca.Length; i++) ca[i] = Marshal(cpt[i].ParameterType, ctorArgs[i]);
        var inst = ctor.Invoke(ca);
        var methods = dc.GetMethods(ANY);
        long acc = 0;
        for (int i = 1; i < ops.Count; i++) {
            string opn = Convert.ToString(ops[i]);
            var oal = (List<object>)args[i];
            var m = methods.First(mm => string.Equals(mm.Name, opn, StringComparison.OrdinalIgnoreCase)
                                        && mm.GetParameters().Length == oal.Count);
            var mpt = m.GetParameters();
            var oa = new object[mpt.Length];
            for (int j = 0; j < oa.Length; j++) oa[j] = Marshal(mpt[j].ParameterType, oal[j]);
            acc = Fold(acc, m.Invoke(inst, oa));
        }
        return acc;
    }

    static string Truncate(string x, int n) => x.Length <= n ? x : x.Substring(0, n);

    // ---------- full-suite correctness validation (dotnet bench.dll validate) ----------
    // Runs EVERY reference case once and compares to the expected output. For
    // design/trace cases a null in the expected array marks a void op (LeetCode
    // discards its return), so those positions are not compared.
    static bool IsNum(object r) => r is int || r is long || r is short || r is byte;
    static List<string> ReplayResults(Type dc, List<object> ops, List<object> args, bool randomized) {
        var ctorArgs = (List<object>)args[0];
        var ctor = dc.GetConstructors().First(ct => ct.GetParameters().Length == ctorArgs.Count);
        var cpt = ctor.GetParameters();
        var ca = new object[cpt.Length];
        for (int i = 0; i < ca.Length; i++) ca[i] = Marshal(cpt[i].ParameterType, ctorArgs[i]);
        var inst = ctor.Invoke(ca);
        var methods = dc.GetMethods(ANY);
        List<object> nums = (randomized && ctorArgs.Count > 0) ? ctorArgs[0] as List<object> : null;
        var res = new List<string> { "null" };                    // constructor slot
        for (int i = 1; i < ops.Count; i++) {
            string opn = Convert.ToString(ops[i]);
            var oal = (List<object>)args[i];
            var m = methods.First(mm => string.Equals(mm.Name, opn, StringComparison.OrdinalIgnoreCase)
                                        && mm.GetParameters().Length == oal.Count);
            var mpt = m.GetParameters();
            var oa = new object[mpt.Length];
            for (int j = 0; j < oa.Length; j++) oa[j] = Marshal(mpt[j].ParameterType, oal[j]);
            object r = m.Invoke(inst, oa);
            // random-pick: pick returns a valid index; reference stores nums[index].
            if (randomized && string.Equals(opn, "pick", StringComparison.OrdinalIgnoreCase) && nums != null && r != null && IsNum(r))
                r = nums[(int)Convert.ToInt64(r)];
            res.Add(Canon(r));
        }
        return res;
    }
    // LeetCode accepts these answers in ANY order (special judge) -> multiset compare.
    static readonly HashSet<string> _UNORDERED = new HashSet<string> {
        "uncommon-words-from-two-sentences", "remove-invalid-parentheses",
        "restore-the-array-from-adjacent-pairs" };
    static List<string> ElemCanons(object o) {
        if (o is string) return null;                          // a string is not a flat list-result
        if (o is System.Collections.IEnumerable en) {
            var r = new List<string>();
            foreach (var e in en) r.Add(Canon(e));
            return r;
        }
        return null;
    }
    static bool UnorderedEq(object a, object e) {
        var la = ElemCanons(a); var le = ElemCanons(e);
        if (la == null || le == null) return Canon(a) == Canon(e);
        la.Sort(StringComparer.Ordinal); le.Sort(StringComparer.Ordinal);
        return la.SequenceEqual(le);
    }
    static int VFail(string slug, string name, object exp, object actual) {
        Console.Error.WriteLine($"VALIDATE slug={slug} FAIL case={name} expected={Truncate(Convert.ToString(exp), 120)} actual={Truncate(Convert.ToString(actual), 120)}");
        return 1;
    }
    static int Validate() {
        string cwd = Directory.GetCurrentDirectory();
        string slug = Path.GetFileName(cwd.TrimEnd('/', '\\'));
        string refdir = Path.Combine(cwd, "..", "..", "..", "reference", "leetcode");
        List<object> cases; string method;
        try {
            var outObj = (OMap)Parse(File.ReadAllText(Path.Combine(refdir, "outputs", slug + ".json")));
            var wl = (OMap)Parse(File.ReadAllText(Path.Combine(refdir, "workloads", slug + ".json")));
            string ep = Convert.ToString(wl.Get("entry_point")); method = ep.Substring(ep.LastIndexOf('.') + 1);
            cases = (List<object>)outObj.Get("expected");
        } catch (Exception e) { Console.Error.WriteLine($"VALIDATE slug={slug} ERROR load: {e.Message}"); return 2; }
        bool randomized = slug == "random-pick-index";
        foreach (var co in cases) {
            var c = (OMap)co; string name = Convert.ToString(c.Get("name"));
            var input = (OMap)c.Get("input");
            object expected = c.Get("output");
            try {
                if (input.Has("ops") && input.Has("args")) {
                    var ops = (List<object>)input.Get("ops");
                    var dargs = (List<object>)input.Get("args");
                    Type dc = FindType(Convert.ToString(ops[0])) ?? FindType("Solution");
                    var actual = ReplayResults(dc, ops, dargs, randomized);
                    var exp = (List<object>)expected;
                    if (actual.Count != exp.Count) return VFail(slug, name, Canon(exp), Canon(actual));
                    for (int i = 0; i < exp.Count; i++) {
                        if (exp[i] == null) continue;                 // void op: not compared
                        if (Canon(exp[i]) != actual[i]) return VFail(slug, name, Canon(exp), Canon(actual));
                    }
                } else {
                    Type sol = FindType("Solution");
                    MethodInfo mth = sol.GetMethods(PUB).FirstOrDefault(m => string.Equals(m.Name, method, StringComparison.OrdinalIgnoreCase))
                                  ?? sol.GetMethods(ANY).FirstOrDefault(m => string.Equals(m.Name, method, StringComparison.OrdinalIgnoreCase));
                    object inst = Activator.CreateInstance(sol);
                    var pts = mth.GetParameters();
                    var baseArgs = new object[pts.Length];
                    int k = 0; foreach (var v in input.Vals) { baseArgs[k] = Marshal(pts[k].ParameterType, v); k++; }
                    object rawResult = mth.Invoke(inst, baseArgs);
                    bool okc = _UNORDERED.Contains(slug) ? UnorderedEq(rawResult, expected) : (Canon(rawResult) == Canon(expected));
                    if (!okc) return VFail(slug, name, Canon(expected), Canon(rawResult));
                }
            } catch (Exception e) {
                var cz = (e is TargetInvocationException tie && tie.InnerException != null) ? tie.InnerException : e;
                Console.Error.WriteLine($"VALIDATE slug={slug} RE case={name} {cz.GetType().Name}: {cz.Message}");
                return 3;
            }
        }
        Console.Error.WriteLine($"VALIDATE slug={slug} PASS ncases={cases.Count}");
        return 0;
    }

    public static int Main(string[] argv) {
        if (argv.Length >= 1 && argv[0] == "validate") return Validate();
        double budget = double.Parse(argv[0], CultureInfo.InvariantCulture);
        int idx = int.Parse(argv[1]);
        string cwd = Directory.GetCurrentDirectory();
        string slug = Path.GetFileName(cwd.TrimEnd('/', '\\'));
        string refdir = Path.Combine(cwd, "..", "..", "..", "reference", "leetcode");

        var outObj = (OMap)Parse(File.ReadAllText(Path.Combine(refdir, "outputs", slug + ".json")));
        var cases = (List<object>)outObj.Get("expected");
        var c = (OMap)cases[idx];
        string name = Convert.ToString(c.Get("name"));
        var input = (OMap)c.Get("input");
        double warm = budget * 0.3;
        long acc = 0, iters = 0;

        // design-class replay
        if (input.Has("ops") && input.Has("args")) {
            var ops = (List<object>)input.Get("ops");
            var dargs = (List<object>)input.Get("args");
            Type dc = FindType(Convert.ToString(ops[0])) ?? FindType("Solution");
            Replay(dc, ops, dargs);
            long warmItersD = 0;
            var sw = Stopwatch.StartNew();
            while (sw.Elapsed.TotalSeconds < warm) { Replay(dc, ops, dargs); warmItersD++; }
            double perIterD = sw.Elapsed.TotalSeconds / Math.Max(warmItersD, 1);
            if (perIterD <= 0) perIterD = 1e-9;
            long batchD = (long)(0.002 / perIterD); if (batchD < 1) batchD = 1; if (batchD > 4096) batchD = 4096;
            var sw2 = Stopwatch.StartNew();
            while (sw2.Elapsed.TotalSeconds < budget - warm) {
                for (long bi = 0; bi < batchD; bi++) acc = unchecked(acc * 1000003 + Replay(dc, ops, dargs));
                iters += batchD;
            }
            double measD = sw2.Elapsed.TotalSeconds;
            Console.Error.WriteLine($"CASE={name} ITERS={iters} ACC={acc} MEAS_S={measD.ToString("F6", CultureInfo.InvariantCulture)} BEACON=design");
            return 0;
        }

        // generic method call
        var wl = (OMap)Parse(File.ReadAllText(Path.Combine(refdir, "workloads", slug + ".json")));
        string ep = Convert.ToString(wl.Get("entry_point"));
        string method = ep.Substring(ep.LastIndexOf('.') + 1);
        Type sol = FindType("Solution");
        MethodInfo mth = sol.GetMethods(PUB).FirstOrDefault(m => string.Equals(m.Name, method, StringComparison.OrdinalIgnoreCase))
                      ?? sol.GetMethods(ANY).FirstOrDefault(m => string.Equals(m.Name, method, StringComparison.OrdinalIgnoreCase));
        object inst = Activator.CreateInstance(sol);
        var pts = mth.GetParameters();
        var baseArgs = new object[pts.Length];
        int k = 0;
        foreach (var v in input.Vals) { baseArgs[k] = Marshal(pts[k].ParameterType, v); k++; }

        // Detect once whether the solution mutates its input. Snapshot base, run ONE
        // call on the SHARED base (this is the beacon call), re-snapshot: if the
        // canonical form is unchanged the solution is non-mutating and the measured
        // loop can invoke on the shared base (no per-iteration deep clone); otherwise
        // clone a pristine copy each iteration. When in doubt, clone.
        string snap0 = Snap(baseArgs);
        object[] pristine = CloneAll(baseArgs);              // pristine source for the clone path
        object beacon = mth.Invoke(inst, baseArgs);          // beacon call on shared base
        string beaconStr = Truncate(Canon(beacon), 80);      // capture before any later aliasing
        bool mutates = Snap(baseArgs) != snap0;
        long warmIters = 0;
        var w = Stopwatch.StartNew();
        while (w.Elapsed.TotalSeconds < warm) { mth.Invoke(inst, mutates ? CloneAll(pristine) : baseArgs); warmIters++; }
        double perIter = w.Elapsed.TotalSeconds / Math.Max(warmIters, 1);
        if (perIter <= 0) perIter = 1e-9;
        long batch = (long)(0.002 / perIter); if (batch < 1) batch = 1; if (batch > 4096) batch = 4096;
        var m2 = Stopwatch.StartNew();
        while (m2.Elapsed.TotalSeconds < budget - warm) {
            for (long bi = 0; bi < batch; bi++)
                acc = Fold(acc, mth.Invoke(inst, mutates ? CloneAll(pristine) : baseArgs));
            iters += batch;
        }
        double meas = m2.Elapsed.TotalSeconds;
        Console.Error.WriteLine($"CASE={name} ITERS={iters} ACC={acc} MEAS_S={meas.ToString("F6", CultureInfo.InvariantCulture)} BEACON={beaconStr}");
        return 0;
    }
}
