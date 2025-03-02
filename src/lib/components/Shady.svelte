<script lang="ts">
	import { browser } from '$app/environment';
	import * as THREE from 'three';

	if (browser) {
		const scene = new THREE.Scene();

		const camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 1, 500);
		camera.position.set(0, 0, 45);
		camera.lookAt(0, 0, 0);

		const renderer = new THREE.WebGLRenderer();
		renderer.setSize(window.innerWidth, window.innerHeight);
		renderer.setAnimationLoop(animate);
		document.body.appendChild(renderer.domElement);

		const geometry = new THREE.BoxGeometry(1, 1, 1);
		const material = new THREE.MeshBasicMaterial({ color: 0x00ff00 });
		const cube = new THREE.Mesh(geometry, material);
		// scene.add(cube);

		//create a blue LineBasicMaterial
		const lineBasicMaterial = new THREE.LineBasicMaterial({ color: 0x0000ff });

		const points = [];
		points.push(new THREE.Vector3(-10, 0, 0));
		points.push(new THREE.Vector3(0, 10, 0));
		points.push(new THREE.Vector3(10, 0, 0));

		const bufferGeometry = new THREE.BufferGeometry().setFromPoints(points);

		const line = new THREE.Line(bufferGeometry, lineBasicMaterial);

		scene.add(line);

		// camera.position.z = 5;

		function animate() {
			line.rotation.x += 0.01;
			line.rotation.y += 0.01;

			renderer.render(scene, camera);
		}
	}
</script>

<style>
	:global(body) {
		margin: 0;
	}
</style>
