// LC-energy test suite (TypeScript) — hardcoded single case.
const _sc = new StreamChecker(["a", "b", "c"]);
const _r = _sc.query("a");
if (_r === undefined) { console.log("void"); }
