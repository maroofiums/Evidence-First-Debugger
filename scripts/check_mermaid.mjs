import { JSDOM } from "jsdom";
import fs from "fs";
const dom = new JSDOM("<!DOCTYPE html><body></body>");
globalThis.window = dom.window;
globalThis.document = dom.window.document;
Object.defineProperty(globalThis, "navigator", { value: dom.window.navigator, configurable: true });
const mermaid = (await import("mermaid")).default;
mermaid.initialize({ startOnLoad: false, securityLevel: "strict" });
const md = fs.readFileSync(process.argv[2] || "README.md", "utf8");
const blocks = [...md.matchAll(/```mermaid\n([\s\S]*?)```/g)].map(m => m[1]);
let bad = 0;
for (const [i, b] of blocks.entries()) {
  try { await mermaid.parse(b); console.log(`block ${i+1}: ok (${b.split("\n")[0].trim()})`); }
  catch (e) { bad++; console.log(`block ${i+1}: FAIL ${String(e.message || e).split("\n").slice(0,3).join(" | ")}`); }
}
console.log(bad ? `${bad} block(s) failed` : "all mermaid blocks parse");
process.exit(bad ? 1 : 0);
