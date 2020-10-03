using System.Collections;
using System.Collections.Generic;
using Cinemachine;
using UnityEngine;
using UnityEngine.Events;

public class SimpleCameraShakeInCinemachine : MonoBehaviour {

    public float ShakeDuration = 0.3f; // Time the Camera Shake effect will last
    public float ShakeAmplitude = 1.2f; // Cinemachine Noise Profile Parameter
    public float ShakeFrequency = 2.0f; // Cinemachine Noise Profile Parameter

    private float ShakeElapsedTime = 0f;

    // Cinemachine Shake
    private CinemachineVirtualCamera VirtualCameraV;
    private CinemachineBasicMultiChannelPerlin virtualCameraNoiseV;

    // Use this for initialization
    void Start () {

    }

    public void AddShakeTime (float time) {
        ShakeElapsedTime += time;
    }

    [NaughtyAttributes.Button]
    public void ShakeCamera () {
        ShakeElapsedTime = ShakeDuration;
    }
    public Cinemachine.CinemachineBasicMultiChannelPerlin virtualCameraNoise {
        get {
            if (virtualCameraNoiseV == null) {
                virtualCameraNoiseV = VirtualCamera.GetCinemachineComponent<Cinemachine.CinemachineBasicMultiChannelPerlin> ();
            }
            return virtualCameraNoiseV;
        }
    }
    public CinemachineVirtualCamera VirtualCamera {
        get {
            return VirtualCameraV;
        }
    }

    // Update is called once per frame
    void Update () {
        // TODO: Replace with your trigger

        // If the Cinemachine componet is not set, avoid update
        //if (VirtualCamera != null && virtualCameraNoise != null) {
        // If Camera Shake effect is still playing
        if (ShakeElapsedTime > 0) {
            // Set Cinemachine Camera Noise parameters
            virtualCameraNoise.m_AmplitudeGain = ShakeAmplitude;
            virtualCameraNoise.m_FrequencyGain = ShakeFrequency;

            // Update Shake Timer
            ShakeElapsedTime -= Time.deltaTime;
        } else {
            // If Camera Shake effect is over, reset variables
            virtualCameraNoise.m_AmplitudeGain = 0f;
            ShakeElapsedTime = 0f;
        }
    }
}