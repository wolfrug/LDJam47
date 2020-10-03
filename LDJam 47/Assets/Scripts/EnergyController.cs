using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

[System.Serializable]
public class EnergyReduced : UnityEvent<BasicAgent, float> { }

[System.Serializable]
public class EnergyIncreased : UnityEvent<BasicAgent, float> { }

[System.Serializable]
public class EnergyDepleted : UnityEvent<BasicAgent, float> { }

public class EnergyController : MonoBehaviour {
    public Vector2 minMaxEnergy = new Vector2 (0f, 10f);
    public float currentEnergy = 10f;
    public BasicAgent attachedAgent;
    public GenericHealthBar energyBar;

    public EnergyReduced evt_energyDown;
    public EnergyIncreased evt_energyUp;
    public EnergyDepleted evt_energyOut;
    // Controls how the player uses his energy and kills the player if they run out :(
    // Start is called before the first frame update
    void Start () {
        if (energyBar != null) {
            energyBar.minMaxHealth = minMaxEnergy;
            energyBar.currentHealth = currentEnergy;
        };
    }

    public void ChangeEnergy (float amount) {
        float oldEnergy = currentEnergy;
        currentEnergy = Mathf.Clamp (currentEnergy += amount, minMaxEnergy.x, minMaxEnergy.y);
        if (oldEnergy > currentEnergy) {
            evt_energyDown.Invoke (attachedAgent, oldEnergy - currentEnergy);
        } else if (oldEnergy < currentEnergy) {
            evt_energyUp.Invoke (attachedAgent, currentEnergy - oldEnergy);
        } else if (currentEnergy <= minMaxEnergy.x && amount < 0f) {
            evt_energyOut.Invoke (attachedAgent, amount);
        }
        energyBar.currentHealth = currentEnergy;
    }

    // Update is called once per frame
    void Update () {

    }
}