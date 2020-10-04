using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Jetpack : MonoBehaviour {
    // Start is called before the first frame update
    bool m_jumping = false;
    bool isFlying = false;

    public EnergyController energyController;
    public float jetPackEnergyCost = 0.01f;

    bool active = true;
    public float maxSpeed = 10f;
    public float jetPackStrength = 1f;
    public ParticleSystem jetPackParticles;
    public Rigidbody2D rb;
    void Start () {

    }

    public void SetActive (bool activation) {
        active = activation;
    }

    void Update () {
        if (Input.GetButton ("Jump") && active && energyController.currentEnergy > energyController.minMaxEnergy.x) {
            m_jumping = true;
        } else {
            m_jumping = false;
        }
    }
    // Update is called once per frame
    void FixedUpdate () {
        if (m_jumping) {
            energyController.ChangeEnergy (-jetPackEnergyCost);
            if (rb.velocity.y < maxSpeed) {
                rb.AddForce (new Vector2 (0f, jetPackStrength));
            };
            if (!isFlying) {
                jetPackParticles.Play (true);
                //JetPackSound ();
                isFlying = true;
            };
        } else {
            jetPackParticles.Stop (true);
            isFlying = false;
            //audioSource.StopLoop ();
        };
    }
}