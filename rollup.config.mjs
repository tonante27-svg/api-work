import { nodeResolve } from "@rollup/plugin-node-resolve";

export default {
  input: "scripts/openlayers-entry.js",

  plugins: [nodeResolve()],

  output: {
    file: "dist/openlayers.js",
    format: "iife",
    name: "OpenLayersBundle"
  }
};
