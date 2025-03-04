<script lang="ts">
	import fragmentShader from './shaders/fragment-shader.glsl?raw';
	import { loop } from '../../../shader-x-engine/loop.js';
	import vertexShader from './shaders/vertex-shader.glsl?raw';
	import { makeWindowResizeHandler } from '../../../shader-x-engine/make-window-resize-handler.js';
	import { browser } from '$app/environment';
	import { boot } from '../../../shader-x-engine/boot.js';

	if (browser) {
		(async () => {
			const { camera, material, renderer, scene } = boot({
				fragmentShader,
				height: window.innerHeight,
				vertexShader,
				width: window.innerWidth
			});

			window.document.body.appendChild(renderer.domElement);

			const onWindowResize = makeWindowResizeHandler({ material, renderer, window });

			window.addEventListener('resize', onWindowResize, false);

			onWindowResize();

			const timer = { previousTime: 0, totalTime: 0 };

			loop({ camera, material, renderer, scene, timer });
		})();
	}
</script>

<style>
	:global(body) {
		margin: 0;
	}
</style>
