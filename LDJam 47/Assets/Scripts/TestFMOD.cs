using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestFMOD : MonoBehaviour
{
    public float minRPM = 0f;
    public float maxRPM = 5000f;
    public float currentSpeed = 10f;
    // Start is called before the first frame update
    void Start()
    {

    }

    bool audioResumed = false;

    public void ResumeAudio()
    {
        if (!audioResumed)
        {
            var result = FMODUnity.RuntimeManager.CoreSystem.mixerSuspend();
            Debug.Log(result);
            result = FMODUnity.RuntimeManager.CoreSystem.mixerResume();
            Debug.Log(result);
            audioResumed = true;
        }
    }

    public void ChangeSpeed(float speed)
    {
        currentSpeed = speed;
    }

    // Update is called once per frame
    void Update()
    {
        float effectiveRPM = Mathf.Lerp(minRPM, maxRPM, currentSpeed);
        var emitter = GetComponent<FMODUnity.StudioEventEmitter>();
        emitter.SetParameter("RPM", effectiveRPM);
    }
}
