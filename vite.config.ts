import { defineConfig } from "vitest/config";
import { sveltekit } from "@sveltejs/kit/vite";

const fullReloadAlways = {
  handleHotUpdate({
    server,
  }: {
    server: { ws: { send: (input: { type: string }) => void } };
  }) {
    server.ws.send({ type: "full-reload" });

    return [];
  },

  name: "full-reload-always",
};

export default defineConfig({
  plugins: [sveltekit(), fullReloadAlways],

  server: {
    port: 5173,
  },

  test: {
    include: ["src/**/*.{test,spec}.{js,ts}"],
  },
});
