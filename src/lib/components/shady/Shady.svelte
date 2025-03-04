<script lang="ts">
  import fragmentShader from "./shaders/fragment-shader.glsl?raw";
  import vertexShader from "./shaders/vertex-shader.glsl?raw";
  import { browser } from "$app/environment";
  import { start } from "../../../shader-x-engine/start.js";
  import { onMount } from "svelte";

  onMount(() => {
    if (browser) {
      start({ fragmentShader, vertexShader, window });
    }
  });
</script>

<style>
  :global(body) {
    margin: 0;
  }
</style>
