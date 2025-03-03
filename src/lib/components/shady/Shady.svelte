<script lang="ts">
	import { browser } from '$app/environment';
	import { on } from 'svelte/events';
	import {
		Mesh,
		OrthographicCamera,
		PlaneGeometry,
		Scene,
		ShaderMaterial,
		Vector2,
		WebGLRenderer
	} from 'three';

	console.log(import.meta.url);

	let previousTime: number | null = null;
	let totalTime: number = 0;

	const boot = async () => {
		const renderer = new WebGLRenderer();

		const scene = new Scene();

		const camera = new OrthographicCamera(0, 1, 1, 0, 0.1, 1000);

		camera.position.set(0, 0, 1);

		const vsh = await fetch('./src/lib/components/shady/shaders/vertex-shader.glsl');
		const fsh = await fetch('./src/lib/components/shady/shaders/fragment-shader.glsl');

		const material = new ShaderMaterial({
			fragmentShader: await fsh.text(),
			uniforms: {
				resolution: { value: new Vector2(window.innerWidth, window.innerHeight) },
				time: { value: 0.0 }
			},
			vertexShader: await vsh.text()
		});

		const geometry = new PlaneGeometry(1, 1);

		const plane = new Mesh(geometry, material);

		plane.position.set(0.5, 0.5, 0);

		scene.add(plane);

		document.body.appendChild(renderer.domElement);

		const app = {
			camera,
			material,
			renderer,
			scene
		};

		const onWindowResize = makeOnWindowResize({ camera, material, renderer, window });

		window.addEventListener('resize', onWindowResize, false);

		onWindowResize();

		loop({ camera, material, renderer, scene });
	};

	const loop = ({ camera, material, renderer, scene }) => {
		requestAnimationFrame((time) => {
			if (previousTime === null) {
				previousTime = time;
			}

			step(material, time - previousTime);

			renderer.render(scene, camera);

			loop({ camera, material, renderer, scene });

			previousTime = time;
		});
	};

	const step = (material, timeElapsed) => {
		const timeElapsedS = timeElapsed * 0.001;

		totalTime += timeElapsedS;

		material.uniforms.time.value = totalTime;
	};

	const makeOnWindowResize = ({ camera, material, renderer, window }) => {
		return () => {
			const dpr = window.devicePixelRatio;

			const canvas = renderer.domElement;

			canvas.style.width = window.innerWidth + 'px';
			canvas.style.height = window.innerHeight + 'px';

			const w = canvas.clientWidth;
			const h = canvas.clientHeight;

			renderer.setSize(w * dpr, h * dpr, false);

			material.uniforms.resolution.value = new Vector2(
				window.innerWidth * dpr,
				window.innerHeight * dpr
			);
		};
	};

	browser && boot();
</script>

<style>
	:global(body) {
		margin: 0;
	}
</style>
