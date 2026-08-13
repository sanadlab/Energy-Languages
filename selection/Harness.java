// Generic Java loop-harness for the cross-language transfer check.
// Reads the SAME shared JSON inputs as the Python harness, marshals each value
// into the Solution method's typed parameters via reflection, and loops the call
// to a wall-time budget (checksum-consumed, iteration-counted). Reflection makes
// the call opaque to the JIT, so it cannot hoist/eliminate the loop body.
//
//   java Harness <budget_seconds> <case_index>
//   - slug derived from the cell directory name (Java/leetcode/<slug>/)
//   - inputs from ../../../reference/leetcode/{outputs,workloads}/<slug>.json
//   - prints CASE/ITERS/ACC/BEACON to STDERR (stdout stays empty -> validate ok)
// Handles plain-data, TreeNode/ListNode (constructed from serialized input), and
// design classes (input {ops,args} -> constructor + method replay).

import java.io.*;
import java.lang.reflect.*;
import java.math.BigInteger;
import java.nio.file.*;
import java.util.*;

class TreeNode { int val; TreeNode left, right; TreeNode(int v){ val=v; } }
class ListNode { int val; ListNode next; ListNode(int v){ val=v; } }

public class Harness {
    // ---------- minimal JSON parser ----------
    static String s; static int p;
    static Object parse(String in){ s=in; p=0; ws(); return val(); }
    static void ws(){ while(p<s.length() && Character.isWhitespace(s.charAt(p))) p++; }
    static Object val(){
        ws(); char c=s.charAt(p);
        if(c=='{') return obj();
        if(c=='[') return arr();
        if(c=='"') return str();
        if(c=='t'){ p+=4; return Boolean.TRUE; }
        if(c=='f'){ p+=5; return Boolean.FALSE; }
        if(c=='n'){ p+=4; return null; }
        return num();
    }
    static Map<String,Object> obj(){
        LinkedHashMap<String,Object> m=new LinkedHashMap<>(); p++; ws();
        if(s.charAt(p)=='}'){ p++; return m; }
        while(true){ ws(); String k=str(); ws(); p++; Object v=val(); m.put(k,v); ws();
            if(s.charAt(p)==','){ p++; continue; } p++; break; }
        return m;
    }
    static List<Object> arr(){
        ArrayList<Object> a=new ArrayList<>(); p++; ws();
        if(s.charAt(p)==']'){ p++; return a; }
        while(true){ a.add(val()); ws(); if(s.charAt(p)==','){ p++; continue; } p++; break; }
        return a;
    }
    static String str(){
        StringBuilder b=new StringBuilder(); p++;
        while(true){ char c=s.charAt(p++); if(c=='"') break;
            if(c=='\\'){ char e=s.charAt(p++);
                switch(e){ case 'n': b.append('\n'); break; case 't': b.append('\t'); break;
                    case 'r': b.append('\r'); break; case '"': b.append('"'); break;
                    case '\\': b.append('\\'); break; case '/': b.append('/'); break;
                    case 'u': b.append((char)Integer.parseInt(s.substring(p,p+4),16)); p+=4; break;
                    default: b.append(e); } }
            else b.append(c); }
        return b.toString();
    }
    static Object num(){
        int st=p; boolean dbl=false;
        while(p<s.length()){ char c=s.charAt(p);
            if(c=='-'||c=='+'||(c>='0'&&c<='9')){ p++; }
            else if(c=='.'||c=='e'||c=='E'){ dbl=true; p++; } else break; }
        String t=s.substring(st,p);
        if(dbl) return Double.parseDouble(t);
        try { return Long.parseLong(t); } catch(NumberFormatException e){ return new BigInteger(t); }
    }

    // ---------- marshal parsed JSON -> typed Java argument ----------
    @SuppressWarnings("unchecked")
    static Object marshal(Type t, Object v){
        if(t instanceof Class){ Class<?> c=(Class<?>)t;
            if(c==int.class||c==Integer.class) return ((Number)v).intValue();
            if(c==long.class||c==Long.class) return ((Number)v).longValue();
            if(c==double.class||c==Double.class) return ((Number)v).doubleValue();
            if(c==boolean.class||c==Boolean.class) return (Boolean)v;
            if(c==char.class||c==Character.class) return ((String)v).charAt(0);
            if(c==String.class) return (String)v;
            if(c==TreeNode.class) return buildTree((List<Object>)v);
            if(c==ListNode.class) return buildList((List<Object>)v);
            if(c==int[].class){ List<Object> l=(List<Object>)v; int[] a=new int[l.size()];
                for(int i=0;i<a.length;i++) a[i]=((Number)l.get(i)).intValue(); return a; }
            if(c==long[].class){ List<Object> l=(List<Object>)v; long[] a=new long[l.size()];
                for(int i=0;i<a.length;i++) a[i]=((Number)l.get(i)).longValue(); return a; }
            if(c==double[].class){ List<Object> l=(List<Object>)v; double[] a=new double[l.size()];
                for(int i=0;i<a.length;i++) a[i]=((Number)l.get(i)).doubleValue(); return a; }
            if(c==boolean[].class){ List<Object> l=(List<Object>)v; boolean[] a=new boolean[l.size()];
                for(int i=0;i<a.length;i++) a[i]=(Boolean)l.get(i); return a; }
            if(c==String[].class){ List<Object> l=(List<Object>)v; String[] a=new String[l.size()];
                for(int i=0;i<a.length;i++) a[i]=(String)l.get(i); return a; }
            if(c==int[][].class){ List<Object> l=(List<Object>)v; int[][] a=new int[l.size()][];
                for(int i=0;i<a.length;i++) a[i]=(int[])marshal(int[].class,l.get(i)); return a; }
            if(c==String[][].class){ List<Object> l=(List<Object>)v; String[][] a=new String[l.size()][];
                for(int i=0;i<a.length;i++) a[i]=(String[])marshal(String[].class,l.get(i)); return a; }
            if(c==char[].class){ return ((String)v).toCharArray(); }
            if(c==char[][].class){ List<Object> l=(List<Object>)v; char[][] a=new char[l.size()][];
                for(int i=0;i<a.length;i++){ Object row=l.get(i);
                    a[i]= row instanceof String ? ((String)row).toCharArray() : listToCharArr((List<Object>)row); }
                return a; }
        }
        if(t instanceof ParameterizedType){ ParameterizedType pt=(ParameterizedType)t;
            Type et=pt.getActualTypeArguments()[0]; List<Object> l=(List<Object>)v;
            ArrayList<Object> out=new ArrayList<>(); for(Object o:l) out.add(marshal(et,o)); return out; }
        throw new RuntimeException("unhandled type "+t);
    }
    static char[] listToCharArr(List<Object> l){ char[] a=new char[l.size()];
        for(int i=0;i<a.length;i++) a[i]=((String)l.get(i)).charAt(0); return a; }

    static TreeNode buildTree(List<Object> l){
        if(l==null||l.isEmpty()||l.get(0)==null) return null;
        TreeNode root=new TreeNode(((Number)l.get(0)).intValue());
        Deque<TreeNode> q=new ArrayDeque<>(); q.add(root); int i=1;
        while(i<l.size() && !q.isEmpty()){ TreeNode n=q.poll();
            if(i<l.size()){ Object lv=l.get(i++); if(lv!=null){ n.left=new TreeNode(((Number)lv).intValue()); q.add(n.left); } }
            if(i<l.size()){ Object rv=l.get(i++); if(rv!=null){ n.right=new TreeNode(((Number)rv).intValue()); q.add(n.right); } } }
        return root;
    }
    static ListNode buildList(List<Object> l){
        if(l==null||l.isEmpty()) return null;
        ListNode head=new ListNode(((Number)l.get(0)).intValue()), cur=head;
        for(int i=1;i<l.size();i++){ cur.next=new ListNode(((Number)l.get(i)).intValue()); cur=cur.next; }
        return head;
    }

    // ---------- deep clone args each iteration (mutation safety) ----------
    static Object clone1(Object o){
        if(o instanceof int[]) return ((int[])o).clone();
        if(o instanceof long[]) return ((long[])o).clone();
        if(o instanceof double[]) return ((double[])o).clone();
        if(o instanceof boolean[]) return ((boolean[])o).clone();
        if(o instanceof String[]) return ((String[])o).clone();
        if(o instanceof char[]) return ((char[])o).clone();
        if(o instanceof int[][]){ int[][] a=(int[][])o,b=new int[a.length][]; for(int i=0;i<a.length;i++) b[i]=a[i].clone(); return b; }
        if(o instanceof char[][]){ char[][] a=(char[][])o,b=new char[a.length][]; for(int i=0;i<a.length;i++) b[i]=a[i].clone(); return b; }
        if(o instanceof String[][]){ String[][] a=(String[][])o,b=new String[a.length][]; for(int i=0;i<a.length;i++) b[i]=a[i].clone(); return b; }
        if(o instanceof TreeNode) return cloneTree((TreeNode)o);
        if(o instanceof ListNode) return cloneList((ListNode)o);
        if(o instanceof List){ ArrayList<Object> b=new ArrayList<>(); for(Object e:(List<?>)o) b.add(clone1(e)); return b; }
        return o;
    }
    static TreeNode cloneTree(TreeNode n){ if(n==null) return null; TreeNode c=new TreeNode(n.val); c.left=cloneTree(n.left); c.right=cloneTree(n.right); return c; }
    static ListNode cloneList(ListNode n){ if(n==null) return null; ListNode h=new ListNode(n.val),c=h; n=n.next; while(n!=null){ c.next=new ListNode(n.val); c=c.next; n=n.next; } return h; }

    static String canon(Object r){
        if(r==null) return "null";
        if(r instanceof ListNode){ StringBuilder b=new StringBuilder("["); for(ListNode n=(ListNode)r; n!=null; n=n.next){ if(b.length()>1) b.append(", "); b.append(n.val); } return b.append("]").toString(); }
        if(r instanceof TreeNode){ java.util.List<String> out=new java.util.ArrayList<>(); java.util.LinkedList<TreeNode> q=new java.util.LinkedList<>(); q.add((TreeNode)r); while(!q.isEmpty()){ TreeNode n=q.poll(); if(n==null){ out.add("null"); continue; } out.add(String.valueOf(n.val)); q.add(n.left); q.add(n.right); } int e=out.size(); while(e>0 && out.get(e-1).equals("null")) e--; return "["+String.join(", ", out.subList(0,e))+"]"; }
        if(r instanceof int[]) return Arrays.toString((int[])r);
        if(r instanceof long[]) return Arrays.toString((long[])r);
        if(r instanceof double[]) return Arrays.toString((double[])r);
        if(r instanceof boolean[]) return Arrays.toString((boolean[])r);
        if(r instanceof int[][]) return Arrays.deepToString((int[][])r);
        if(r instanceof Object[]) return Arrays.deepToString((Object[])r);
        return String.valueOf(r);
    }

    @SuppressWarnings("unchecked")
    static long replay(Class<?> dc, List<Object> ops, List<Object> args) throws Exception {
        List<Object> ctorArgs=(List<Object>)args.get(0);
        Constructor<?> ctor=null;
        for(Constructor<?> ct: dc.getDeclaredConstructors()) if(ct.getParameterCount()==ctorArgs.size()){ ctor=ct; break; }
        ctor.setAccessible(true);
        Type[] cpt=ctor.getGenericParameterTypes(); Object[] ca=new Object[cpt.length];
        for(int i=0;i<ca.length;i++) ca[i]=marshal(cpt[i], ctorArgs.get(i));
        Object inst=ctor.newInstance(ca);
        long acc=0;
        for(int i=1;i<ops.size();i++){
            String opn=(String)ops.get(i); List<Object> oal=(List<Object>)args.get(i);
            Method m=null;
            for(Method mm: dc.getDeclaredMethods()) if(mm.getName().equals(opn) && mm.getParameterCount()==oal.size()){ m=mm; break; }
            m.setAccessible(true);
            Type[] mpt=m.getGenericParameterTypes(); Object[] oa=new Object[mpt.length];
            for(int j=0;j<oa.length;j++) oa[j]=marshal(mpt[j], oal.get(j));
            acc=acc*1000003 + canon(m.invoke(inst, oa)).hashCode();
        }
        return acc;
    }

    @SuppressWarnings("unchecked")
    public static void main(String[] args) throws Exception {
        double budget = Double.parseDouble(args[0]);
        int idx = Integer.parseInt(args[1]);
        String cell = System.getProperty("user.dir");
        String slug = new File(cell).getName();
        String ref = cell + "/../../../reference/leetcode";
        Map<String,Object> out = (Map<String,Object>) parse(new String(Files.readAllBytes(Paths.get(ref,"outputs",slug+".json"))));
        List<Object> cases = (List<Object>) out.get("expected");
        Map<String,Object> c = (Map<String,Object>) cases.get(idx);
        String name = String.valueOf(c.get("name"));
        Map<String,Object> input = (Map<String,Object>) c.get("input");
        long acc=0, iters=0, t0, tm; double warm=budget*0.3;

        if(input.containsKey("ops") && input.containsKey("args")){       // design-class replay
            List<Object> ops=(List<Object>)input.get("ops"); List<Object> dargs=(List<Object>)input.get("args");
            Class<?> dc;
            try { dc=Class.forName(String.valueOf(ops.get(0))); }
            catch(ClassNotFoundException e){ dc=Class.forName("Solution"); }  // solution named the class differently
            replay(dc, ops, dargs);
            long warmIters=0, wt=0; t0=System.nanoTime();
            while((wt=System.nanoTime()-t0) < (long)(warm*1e9)){ replay(dc, ops, dargs); warmIters++; }
            double perIter=(double)wt/Math.max(warmIters,1)/1e9;
            long batch=(long)(0.002/perIter); if(batch<1) batch=1; if(batch>4096) batch=4096;
            tm=System.nanoTime(); long budgetNs=(long)((budget-warm)*1e9);
            while(System.nanoTime()-tm < budgetNs){
                for(long bi=0; bi<batch; bi++) acc=acc*1000003 + replay(dc,ops,dargs);
                iters+=batch;
            }
            double meas=(System.nanoTime()-tm)/1e9;
            System.err.println("CASE="+name+" ITERS="+iters+" ACC="+acc+" MEAS_S="+String.format(java.util.Locale.ROOT,"%.6f",meas)+" BEACON=design");
            return;
        }
        // generic method call
        Map<String,Object> wl = (Map<String,Object>) parse(new String(Files.readAllBytes(Paths.get(ref,"workloads",slug+".json"))));
        String ep = String.valueOf(wl.get("entry_point"));
        String method = ep.substring(ep.lastIndexOf('.')+1);
        Class<?> sol = Class.forName("Solution");
        Method mth = null;
        for(Method m : sol.getMethods()) if(m.getName().equals(method)){ mth=m; break; }
        if(mth==null) for(Method m : sol.getDeclaredMethods()) if(m.getName().equals(method)){ mth=m; break; }
        Object inst = sol.getDeclaredConstructor().newInstance();
        Type[] pts = mth.getGenericParameterTypes();
        Object[] base = new Object[pts.length];
        int i=0; for(Object v : input.values()){ base[i]=marshal(pts[i], v); i++; }
        // Detect once whether the solution mutates its input. Snapshot base, run ONE
        // call on the SHARED base (this is the beacon call), re-snapshot: if the
        // canonical form is unchanged the solution is non-mutating and the measured
        // loop can invoke on the shared base (no per-iteration deep clone); otherwise
        // clone a pristine copy each iteration. When in doubt, clone.
        String snap0 = snap(base);
        Object[] pristine = cloneAll(base);                  // pristine source for the clone path
        Object beacon = mth.invoke(inst, base);              // beacon call on shared base
        String beaconStr = truncate(canon(beacon),80);       // capture before any later aliasing
        boolean mutates = !snap(base).equals(snap0);
        long warmIters=0, wt=0; t0=System.nanoTime();
        while((wt=System.nanoTime()-t0) < (long)(warm*1e9)){ mth.invoke(inst, mutates? cloneAll(pristine): base); warmIters++; }
        double perIter=(double)wt/Math.max(warmIters,1)/1e9;
        long batch=(long)(0.002/perIter); if(batch<1) batch=1; if(batch>4096) batch=4096;
        tm=System.nanoTime(); long budgetNs=(long)((budget-warm)*1e9);
        while(System.nanoTime()-tm < budgetNs){
            for(long bi=0; bi<batch; bi++) acc=acc*1000003 + canon(mth.invoke(inst, mutates? cloneAll(pristine): base)).hashCode();
            iters+=batch;
        }
        double meas=(System.nanoTime()-tm)/1e9;
        System.err.println("CASE="+name+" ITERS="+iters+" ACC="+acc+" MEAS_S="+String.format(java.util.Locale.ROOT,"%.6f",meas)+" BEACON="+beaconStr);
    }
    static Object[] cloneAll(Object[] a){ Object[] b=new Object[a.length]; for(int i=0;i<a.length;i++) b[i]=clone1(a[i]); return b; }
    // structural snapshot of the argument tuple (reflects contents so an in-place mutation shows up)
    static String snap(Object[] base){ StringBuilder b=new StringBuilder(); for(Object o: base){ snapOne(o,b); b.append('\u0001'); } return b.toString(); }
    static void snapOne(Object o, StringBuilder b){
        if(o instanceof List){ b.append('['); for(Object e:(List<?>)o){ snapOne(e,b); b.append(','); } b.append(']'); }
        else if(o instanceof Object[]){ b.append('['); for(Object e:(Object[])o){ snapOne(e,b); b.append(','); } b.append(']'); }
        else b.append(canon(o));
    }
    static String truncate(String x,int n){ return x.length()<=n? x : x.substring(0,n); }
}
