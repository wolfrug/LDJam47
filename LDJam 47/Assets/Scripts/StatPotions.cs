using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StatPotions : MonoBehaviour {
    public bool isEnergyPotion = false;
    public float increaseAmount = 1f;

    public void TriggerActivate (GameObject trg) {
        BasicAgent agent = trg.GetComponent<BasicAgent> ();
        if (agent != null) {
            // We only do it if they aren't at full health/energy
            if (isEnergyPotion) {
                EnergyController ctrl = agent.GetComponentInChildren<EnergyController> ();
                if (ctrl != null) {
                    if (ctrl.currentEnergy < ctrl.minMaxEnergy.x) {
                        IncreaseStat (agent);
                    }
                }
            } else {
                if (agent.currentHealth < agent.healthMinMax.x) {
                    IncreaseStat (agent);
                }
            }
        }
    }
    public void IncreaseStat (BasicAgent agent) {
        if (isEnergyPotion) {
            agent.GetComponentInChildren<EnergyController> ().ChangeEnergy (increaseAmount);
        } else {
            agent.Heal (increaseAmount);
        }
    }

}