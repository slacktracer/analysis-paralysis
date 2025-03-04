<script lang="ts">
  import * as THREE from "three";

  import { browser } from "$app/environment";

  if (browser) {
    const scene = new THREE.Scene();

    scene.background = new THREE.Color(0x9e9e9e); // Sky blue

    const camera = new THREE.PerspectiveCamera(
      45,
      window.innerWidth / window.innerHeight,
      1,
      500,
    );

    camera.position.set(0, 0, 45);
    camera.lookAt(0, 0, 0);

    const renderer = new THREE.WebGLRenderer();

    renderer.setSize(window.innerWidth, window.innerHeight);
    renderer.setAnimationLoop(animate);

    document.body.appendChild(renderer.domElement);

    const color = 0xffffff;
    const intensity = 1;
    const light = new THREE.DirectionalLight(color, intensity);

    light.position.set(0, 5, 10);
    light.target.position.set(0, 0, 0);

    scene.add(light);
    scene.add(light.target);

    const geometry = new THREE.BoxGeometry(1, 1, 1);
    const material = new THREE.MeshPhongMaterial({
      color: 0xff0000, // red (can also use a CSS color string here)
      flatShading: true,
    });

    const cube = new THREE.Mesh(geometry, material);

    scene.add(cube);

    camera.position.z = 5;

    function animate() {
      cube.rotation.x += 0.01;
      cube.rotation.y += 0.01;

      renderer.render(scene, camera);
    }
  }
</script>

<style>
  :global(body) {
    margin: 0;
  }
</style>
