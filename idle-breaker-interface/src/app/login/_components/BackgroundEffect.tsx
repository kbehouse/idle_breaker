"use client"

import { useRef, useEffect } from "react"
import * as THREE from "three"

const BackgroundEffect = () => {
  const mountRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    const mount = mountRef.current
    if (!mount) return

    const scene = new THREE.Scene()
    const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000)
    camera.position.z = 5

    const renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true })
    renderer.setSize(window.innerWidth, window.innerHeight)
    mount.appendChild(renderer.domElement)

    // Create crystal
    const geometry = new THREE.IcosahedronGeometry(3, 1)
    const material = new THREE.MeshPhongMaterial({
      color: 0x00ffcc,
      wireframe: true,
      shininess: 100,
      specular: 0x111111,
      emissive: 0x000000,
    })
    const crystal = new THREE.Mesh(geometry, material)
    scene.add(crystal)

    // Add ambient light
    const ambientLight = new THREE.AmbientLight(0xffffff, 0.5)
    scene.add(ambientLight)

    // Add point light
    const pointLight = new THREE.PointLight(0xffffff, 1)
    pointLight.position.set(5, 5, 5)
    scene.add(pointLight)

    // Mouse interaction
    const mouse = new THREE.Vector2()
    const targetRotation = new THREE.Vector2()

    const handleMouseMove = (event: MouseEvent) => {
      mouse.x = (event.clientX / window.innerWidth) * 2 - 1
      mouse.y = -(event.clientY / window.innerHeight) * 2 + 1

      targetRotation.x = mouse.y * 0.5
      targetRotation.y = mouse.x * 0.5
    }

    window.addEventListener('mousemove', handleMouseMove)

    // Animation
    const animate = () => {
      requestAnimationFrame(animate)

      // Smooth rotation
      crystal.rotation.x += (targetRotation.x - crystal.rotation.x) * 0.05
      crystal.rotation.y += (targetRotation.y - crystal.rotation.y) * 0.05

      // Pulsating effect
      const scale = 1 + Math.sin(Date.now() * 0.001) * 0.1
      crystal.scale.set(scale, scale, scale)

      renderer.render(scene, camera)
    }

    animate()

    // Handle window resize
    const handleResize = () => {
      camera.aspect = window.innerWidth / window.innerHeight
      camera.updateProjectionMatrix()
      renderer.setSize(window.innerWidth, window.innerHeight)
    }

    window.addEventListener('resize', handleResize)

    // Cleanup
    return () => {
      window.removeEventListener('mousemove', handleMouseMove)
      window.removeEventListener('resize', handleResize)
      if (mount) {
        mount.removeChild(renderer.domElement)
      }
    }
  }, [])

  return <div ref={mountRef} className="fixed inset-0 -z-10" />
}

export default BackgroundEffect
