using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

[System.Serializable]
public class PotionUsed : UnityEvent<bool> { }

[System.Serializable]
public class OutOfPotions : UnityEvent<bool> { }

public class StatPotions : MonoBehaviour {
    public bool isEnergyPotion = false;
    public float increaseAmount = 1f;
    public int uses = 1;
    public GenericHealthBar healthBar;

    public PotionUsed evt_usePotion;
    public OutOfPotions evt_outOfPotions;

    void Awake () {
        if (healthBar != null) {
            healthBar.minMaxHealth = new Vector2 (0f, uses);
        }
    }

    public void TriggerActivate (GameObject trg) {
        BasicAgent agent = trg.GetComponent<BasicAgent> ();
        Debug.Log ("Agent >" + agent);
        if (agent != null) {
            // We only do it if they aren't at full health/energy
            if (isEnergyPotion) {
                EnergyController ctrl = agent.GetComponentInChildren<EnergyController> ();
                Debug.Log ("Energycontroller >" + ctrl);
                if (ctrl != null) {
                    if (ctrl.currentEnergy < ctrl.minMaxEnergy.y) {
                        IncreaseStat (agent);
                    }
                }
            } else {
                if (agent.currentHealth < agent.healthMinMax.y) {
                    IncreaseStat (agent);
                }
            }
        }
    }
    public void IncreaseStat (BasicAgent agent) {
        Debug.Log ("Increasing stats!");
        if (uses > 0) {
            if (isEnergyPotion) {
                agent.GetComponentInChildren<EnergyController> ().ChangeEnergy (increaseAmount);
            } else {
                agent.Heal (increaseAmount);
            }
            uses--;
            if (uses > 0) {
                evt_usePotion.Invoke (isEnergyPotion);
            } else {
                evt_outOfPotions.Invoke (isEnergyPotion);
            }
            if (healthBar != null) {
                healthBar.currentHealth = (float) uses;
            };
        };
    }

}