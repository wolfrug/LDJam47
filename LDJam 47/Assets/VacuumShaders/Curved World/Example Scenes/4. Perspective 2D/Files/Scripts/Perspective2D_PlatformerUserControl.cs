using System;
using UnityEngine;

namespace VacuumShaders.CurvedWorld.Example {
    [RequireComponent (typeof (Perspective2D_PlatformerCharacter))]
    public class Perspective2D_PlatformerUserControl : MonoBehaviour {
        public EnergyController energyController;
        public FMOD_Controller soundController;
        public float jumpCost = -1f;
        public float moveMultiplier = 0.5f;
        private Perspective2D_PlatformerCharacter m_Character;
        private bool m_Jump;
        bool uiButtonJump;
        Vector2 touchPivot;

        private void Awake () {
            m_Character = GetComponent<Perspective2D_PlatformerCharacter> ();
        }

        private void Update () {
            //Get Jump from keyboard
            if (!m_Jump) {
                m_Jump = Input.GetButtonDown ("Jump");
            }

            //Get Jump from touch-screen
            if (uiButtonJump) {
                uiButtonJump = false;
                m_Jump = true;
            }
        }

        private void FixedUpdate () {
            // Read the inputs.
            float h = 0;

            //From touch-screen
            if (Input.touchSupported && Input.touchCount > 0) {
                Touch currentTouch = Input.touches[0];

                if (currentTouch.phase == TouchPhase.Began)
                    touchPivot = currentTouch.position;

                if (Input.touches[0].phase == TouchPhase.Moved ||
                    Input.touches[0].phase == TouchPhase.Stationary) {
                    Vector2 delta = (currentTouch.position - touchPivot).normalized;

                    h = delta.x;
                }
            } else //From keyboard
            {
                h = Input.GetAxis ("Horizontal");
            }

            // Pass all parameters to the character control script.
            m_Character.Move (h, false, m_Jump);
            if (m_Jump) {
                energyController.ChangeEnergy (jumpCost);
            }
            m_Jump = false;
            energyController.ChangeEnergy ((Mathf.Abs (h) * -1f) * moveMultiplier);
            soundController.SetValue (m_Character.m_Rigidbody2D.velocity.magnitude);
        }

        public void UIJumpButtonOn () {
            uiButtonJump = true;
        }
    }
}