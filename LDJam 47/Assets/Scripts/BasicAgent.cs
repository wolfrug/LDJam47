﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

[System.Serializable]
public class AgentDamaged : UnityEvent<BasicAgent, float> { }

[System.Serializable]
public class AgentHealed : UnityEvent<BasicAgent, float> { }

[System.Serializable]
public class AgentKilled : UnityEvent<BasicAgent> { }

public class BasicAgent : MonoBehaviour {
    public Vector2 healthMinMax = new Vector2 (0f, 1f);
    public float currentHealth = 1f;
    public bool alive = true;
    public Animator animator;
    public GenericHealthBar healthBar;
    public AgentDamaged evt_agentDamaged;
    public AgentHealed evt_agentHealed;
    public AgentKilled evt_agentKilled;
    // Start is called before the first frame update
    void Start () {
        if (healthBar != null) {
            healthBar.minMaxHealth = healthMinMax;
            healthBar.currentHealth = currentHealth;
        }
    }

    public void EnergyDamage (BasicAgent agent, float amount) {
        if (agent == this) {
            Damage (Mathf.Abs (amount) * 0.1f);
        };
    }

    public void Kill () {
        alive = false;
        evt_agentKilled.Invoke (this);
        if (animator != null) {
            animator.SetBool ("Dead", true);
        }
    }

    public void Damage (float damage) {
        float oldHealth = currentHealth;
        currentHealth = Mathf.Clamp (currentHealth -= damage, healthMinMax.x, healthMinMax.y);
        if (oldHealth - currentHealth > 0f) {
            evt_agentDamaged.Invoke (this, oldHealth - currentHealth);
        }
        if (currentHealth <= healthMinMax.x) {
            Kill ();
        }
        if (healthBar != null) { healthBar.currentHealth = currentHealth; };
    }
    public void Heal (float healAmount) {
        if (alive) {
            float oldHealth = currentHealth;
            currentHealth = Mathf.Clamp (currentHealth += healAmount, healthMinMax.x, healthMinMax.y);
            if (healAmount > 0f) {
                evt_agentHealed.Invoke (this, currentHealth - oldHealth);
            }
            if (healthBar != null) { healthBar.currentHealth = currentHealth; };
        };
    }

    // Update is called once per frame
    void Update () {

    }
}