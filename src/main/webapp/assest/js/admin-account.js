/* Admin account page behavior. Kept external so JSP EL does not parse JavaScript template literals. */
        // Real-Time Table Client-Side Filter Search
        function filterAccountsTable() {
            const searchVal = document.getElementById("searchInput").value.toLowerCase().trim();
            const typeVal = document.getElementById("typeFilter").value;
            const statusVal = document.getElementById("statusFilter").value;
            
            const rows = document.querySelectorAll("#accountsTable tbody tr");
            let visibleCount = 0;

            rows.forEach(row => {
                if (row.cells.length === 1 && row.cells[0].colSpan === 8) {
                    return; // Skip empty row
                }
                
                const custId = row.getAttribute("data-cust-id").toLowerCase();
                const custName = row.getAttribute("data-cust-name").toLowerCase();
                const accNumber = row.getAttribute("data-acc-number").toLowerCase();
                const accType = row.getAttribute("data-acc-type").toLowerCase();
                const accStatus = row.getAttribute("data-acc-status").toLowerCase();

                // Check text matching
                const matchesText = custId.includes(searchVal) || custName.includes(searchVal) || accNumber.includes(searchVal);
                
                // Check filters
                const matchesType = (typeVal === "all" || accType === typeVal);
                const matchesStatus = (statusVal === "all" || accStatus === statusVal);

                if (matchesText && matchesType && matchesStatus) {
                    row.style.display = "";
                    visibleCount++;
                } else {
                    row.style.display = "none";
                }
            });

            // Handle empty search feedback
            let emptyMsgRow = document.getElementById("emptyMsgRow");
            if (visibleCount === 0) {
                if (!emptyMsgRow) {
                    const tbody = document.querySelector("#accountsTable tbody");
                    emptyMsgRow = document.createElement("tr");
                    emptyMsgRow.id = "emptyMsgRow";
                    emptyMsgRow.innerHTML = `<td colspan="8" style="text-align: center; padding: 30px; color: var(--gray-400); font-weight: 500;">
                                                <i class="bx bx-search-alt" style="font-size: 2.2rem; display: block; margin-bottom: 10px; opacity: 0.6;"></i>
                                                No signatories matches your search constraints.
                                            </td>`;
                    tbody.appendChild(emptyMsgRow);
                } else {
                    emptyMsgRow.style.display = "";
                }
            } else {
                if (emptyMsgRow) {
                    emptyMsgRow.style.display = "none";
                }
            }
        }

        // Close View Statement Modal
        function closeStatementModal() {
            const modal = document.getElementById("statementModal");
            if (modal) {
                modal.style.display = "none";
                window.location.href = window.VGB_CONTEXT_PATH + "/account?action=list";
            }
        }

        // Trigger Account Soft Close
        function triggerSoftCloseAccount(accountId, accountNumber) {
            const secureConfirm = confirm(`Are you absolutely sure you want to CLOSE/TERMINATE bank account: ${accountNumber}?\n\nThis will soft-close the ledger and disable transfers, but preserve database transactions history records.`);
            if (secureConfirm) {
                document.getElementById("closeFormAccountId").value = accountId;
                document.getElementById("closeAccountForm").submit();
            }
        }

        // Trigger Account Hard Delete
        function triggerHardDeleteAccount(accountId, accountNumber) {
            const secureConfirm = confirm(`[CRITICAL WARNING - IRREVERSIBLE ACTION]\n\nAre you absolutely sure you want to PERMANENTLY PURGE account ${accountNumber} and ALL associated customer details?\n\nThis will fully purge customer profiles, repayment loans, card allocations, and signatories junction mappings completely from the live database. This action CANNOT be undone!`);
            if (secureConfirm) {
                document.getElementById("deleteFormAccountId").value = accountId;
                document.getElementById("deleteAccountForm").submit();
            }
        }

        // Multi-Tab navigation within modal
        function switchModalTab(event, paneId) {
            const tabLinks = document.querySelectorAll(".tab-link");
            const tabPanes = document.querySelectorAll(".tab-pane");

            tabLinks.forEach(link => link.classList.remove("active"));
            tabPanes.forEach(pane => pane.classList.remove("active"));

            event.currentTarget.classList.add("active");
            document.getElementById(paneId).classList.add("active");
        }

        // Open Edit Account Modal with AJAX population
        function openEditAccountModal(customerId, accountId) {
            const firstTabLink = document.querySelector(".tab-link");
            if (firstTabLink) {
                const tabLinks = document.querySelectorAll(".tab-link");
                const tabPanes = document.querySelectorAll(".tab-pane");
                tabLinks.forEach(link => link.classList.remove("active"));
                tabPanes.forEach(pane => pane.classList.remove("active"));
                firstTabLink.classList.add("active");
                document.querySelector(".tab-pane").classList.add("active");
            }

            document.getElementById("editAccountForm").reset();
            document.getElementById("tabJointLink").style.display = "none";
            document.getElementById("subclassSavingsFields").style.display = "none";
            document.getElementById("subclassCurrentFields").style.display = "none";

            // Load details via AJAX
            fetch(window.VGB_CONTEXT_PATH + "/account?action=getCustomerDetails&customerId=" + encodeURIComponent(customerId) + "&accountId=" + encodeURIComponent(accountId))
                .then(res => {
                    if (!res.ok) {
                        throw new Error(`Server returned status: ${res.status}`);
                    }
                    return res.json();
                })
                .then(data => {
                    if (data.error) {
                        alert(`Failed to load details: ${data.error}`);
                        return;
                    }

                    // Populate Hidden references
                    document.getElementById("editCustomerId").value = data.customerId;
                    document.getElementById("editAccountId").value = data.accountId;

                    // Tab 1: Primary Profile Details
                    document.getElementById("editFirstName").value = data.firstName || "";
                    document.getElementById("editLastName").value = data.lastName || "";
                    document.getElementById("editEmail").value = data.email || "";
                    document.getElementById("editPhoneNo").value = data.phoneNo || "";
                    document.getElementById("editAddress").value = data.address || "";
                    document.getElementById("editCity").value = data.city || "";
                    document.getElementById("editState").value = data.state || "";
                    document.getElementById("editZipCode").value = data.zipCode || "";
                    document.getElementById("editPanCard").value = data.panCard || "";
                    document.getElementById("editAadhaarCard").value = data.aadhaarCard || "";

                    // Tab 2: Joint Customer details if present
                    if (data.jointCustomer) {
                        document.getElementById("tabJointLink").style.display = "flex";
                        const jData = data.jointCustomer;
                        document.getElementById("editJointCustomerId").value = jData.customerId || "";
                        document.getElementById("editJointFirstName").value = jData.firstName || "";
                        document.getElementById("editJointLastName").value = jData.lastName || "";
                        document.getElementById("editJointEmail").value = jData.email || "";
                        document.getElementById("editJointPhoneNo").value = jData.phoneNo || "";
                        document.getElementById("editJointAddress").value = jData.address || "";
                        document.getElementById("editJointCity").value = jData.city || "";
                        document.getElementById("editJointState").value = jData.state || "";
                        document.getElementById("editJointZipCode").value = jData.zipCode || "";
                        document.getElementById("editJointPanCard").value = jData.panCard || "";
                        document.getElementById("editJointAadhaarCard").value = jData.aadhaarCard || "";
                    } else {
                        document.getElementById("editJointCustomerId").value = "";
                    }

                    // Tab 3: Banking subclass configurations
                    document.getElementById("editHasAtmCard").checked = data.hasAtmCard;
                    document.getElementById("editHasChequeBook").checked = data.hasChequeBook;

                    if ("savings" === data.accountType.toLowerCase()) {
                        document.getElementById("subclassSavingsFields").style.display = "block";
                        document.getElementById("editNomineeName").value = data.nomineeName || "";
                        document.getElementById("editHoldingType").value = data.holdingType || "single";
                        document.getElementById("editDailyWithdrawalLimit").value = data.dailyWithdrawalLimit || "50000.00";
                        
                        if (data.holdingType === "joint") {
                            document.getElementById("tabJointLink").style.display = "flex";
                        }
                    } else if ("current" === data.accountType.toLowerCase()) {
                        document.getElementById("subclassCurrentFields").style.display = "block";
                        document.getElementById("editBusinessName").value = data.businessName || "";
                        document.getElementById("editGstin").value = data.gstin || "";
                        document.getElementById("editOverdraftLimit").value = data.overdraftLimit || "100000.00";
                        document.getElementById("editCompanyCategory").value = data.companyCategory || "";
                        document.getElementById("editCompanyPhone").value = data.companyPhone || "";
                        document.getElementById("editCompanyEmail").value = data.companyEmail || "";
                        document.getElementById("editCompanyAddress").value = data.companyAddress || "";
                        document.getElementById("editCompanyPan").value = data.companyPan || "";
                        document.getElementById("editCompanyAadhaar").value = data.companyAadhaar || "";
                    }

                    // Tab 4: Security
                    document.getElementById("editUsername").value = data.username || "";
                    document.getElementById("editPin").value = ""; 
                    document.getElementById("editPassword").value = ""; 

                    document.getElementById("editAccountModal").style.display = "flex";
                })
                .catch(err => {
                    console.error(err);
                    alert("Error connection failed: Failed to load customer details. Please verify administrative status.");
                });
        }

        // Toggle joint link visibility when select changes in banking tab
        function toggleJointTabOnHoldingChange() {
            const holdingType = document.getElementById("editHoldingType").value;
            const tabLink = document.getElementById("tabJointLink");
            if (holdingType === "joint") {
                tabLink.style.display = "flex";
            } else {
                tabLink.style.display = "none";
                
                if (tabLink.classList.contains("active")) {
                    const tabLinks = document.querySelectorAll(".tab-link");
                    const tabPanes = document.querySelectorAll(".tab-pane");
                    tabLinks.forEach(link => link.classList.remove("active"));
                    tabPanes.forEach(pane => pane.classList.remove("active"));
                    tabLinks[0].classList.add("active");
                    document.querySelector(".tab-pane").classList.add("active");
                }
            }
        }

        // Close Edit Account modal
        function closeEditAccountModal() {
            document.getElementById("editAccountModal").style.display = "none";
        }

        // Client side validation on update form submit
        document.getElementById("editAccountForm").addEventListener("submit", function(e) {
            const phone = document.getElementById("editPhoneNo").value.trim();
            if (phone.length > 0 && (phone.length !== 10 || !/^\d+$/.test(phone))) {
                alert("Primary Phone number must be exactly 10 digits.");
                e.preventDefault();
                return;
            }

            const jointPhone = document.getElementById("editJointPhoneNo").value.trim();
            const holdingType = document.getElementById("editHoldingType") ? document.getElementById("editHoldingType").value : "single";
            if (holdingType === "joint" && jointPhone.length > 0 && (jointPhone.length !== 10 || !/^\d+$/.test(jointPhone))) {
                alert("Joint Phone number must be exactly 10 digits.");
                e.preventDefault();
                return;
            }

            const pin = document.getElementById("editPin").value.trim();
            if (pin.length > 0 && (pin.length !== 4 || !/^\d+$/.test(pin))) {
                alert("Secure PIN must be exactly 4 numeric digits.");
                e.preventDefault();
                return;
            }

            const password = document.getElementById("editPassword").value;
            if (password.length > 0) {
                if (password.length < 8) {
                    alert("Master password must be at least 8 characters long.");
                    e.preventDefault();
                    return;
                }
                if (!/[A-Z]/.test(password) || !/[a-z]/.test(password) || !/\d/.test(password) || !/[^A-Za-z0-9]/.test(password)) {
                    alert("Master password must contain at least one uppercase letter, one lowercase letter, one digit, and one special character.");
                    e.preventDefault();
                    return;
                }
            }
        });


        // =====================================================================
        // ================= WIZARD CONTROLS (SPECIAL FLOW WIZARD) =============
        // =====================================================================
        
        let currentStepIndex = 0;
        let activeFlow = "savings_single"; // savings_single, savings_joint, current
        
        const wizardFlows = {
            savings_single: [
                { id: "wizardStepClassification", title: "Type" },
                { id: "wizardStepPrimaryHolder", title: "Customer Details" },
                { id: "wizardStepNominee", title: "Nominee" },
                { id: "wizardStepPreferences", title: "Preferences" },
                { id: "wizardStepCredentials", title: "Credentials" },
                { id: "wizardStepFunding", title: "Funding" },
                { id: "wizardStepSummary", title: "Summary" }
            ],
            savings_joint: [
                { id: "wizardStepClassification", title: "Type" },
                { id: "wizardStepPrimaryHolder", title: "Holder 1 Details" },
                { id: "wizardStepJointHolder", title: "Holder 2 Details" },
                { id: "wizardStepNominee", title: "Nominee" },
                { id: "wizardStepPreferences", title: "Preferences" },
                { id: "wizardStepCredentials", title: "Credentials" },
                { id: "wizardStepFunding", title: "Funding" },
                { id: "wizardStepSummary", title: "Summary" }
            ],
            current: [
                { id: "wizardStepClassification", title: "Type" },
                { id: "wizardStepCompanyDetails", title: "Company Details" },
                { id: "wizardStepPartnerDetails", title: "Partner Details" },
                { id: "wizardStepPreferences", title: "Preferences" },
                { id: "wizardStepCredentials", title: "Credentials" },
                { id: "wizardStepFunding", title: "Funding" },
                { id: "wizardStepSummary", title: "Summary" }
            ]
        };

        // Open Creation wizard
        function openCreateAccountModal() {
            currentStepIndex = 0;
            document.getElementById("createAccountForm").reset();
            document.getElementById("partnerListContainer").innerHTML = ""; // reset partner cards
            partnerCount = 0;
            
            // Generate auto-generated secure PIN (not entered by admin)
            const autoPin = Math.floor(1000 + Math.random() * 9000).toString();
            document.getElementById("wizPin").value = autoPin;
            document.getElementById("wizAutoPinLabel").innerText = autoPin;

            // Trigger flow updates
            toggleClassificationFlowSelection();
            updateWizardDisplay();
            
            document.getElementById("createAccountModal").style.display = "flex";
        }

        // Close Creation wizard
        function closeCreateAccountModal() {
            document.getElementById("createAccountModal").style.display = "none";
        }

        // Toggle joint Mode select inside Savings step 3
        function toggleJointModeFields() {
            const mode = document.getElementById("wizJointCustomerMode").value;
            if (mode === "existing") {
                document.getElementById("wizJointExistingSelector").style.display = "block";
                document.getElementById("wizJointNewFields").style.display = "none";
            } else {
                document.getElementById("wizJointExistingSelector").style.display = "none";
                document.getElementById("wizJointNewFields").style.display = "flex";
            }
        }

        // Toggle ATM options inside preferences step
        function toggleCardOptionWiz() {
            const isAtmOpted = document.getElementById("wizHasAtmCard").checked;
            document.getElementById("wizAtmCardDetails").style.display = isAtmOpted ? "flex" : "none";
            syncWizAtmCardPreview();
        }

        // Toggle Cheque Book preview visibility inside preferences step
        function toggleChequeOptionWiz() {
            const chequeCheckbox = document.getElementById("wizHasChequeBook");
            if (!chequeCheckbox) return;
            const isChequeOpted = chequeCheckbox.checked;
            const previewContainer = document.getElementById("wizChequePreviewContainer");
            if (previewContainer) {
                previewContainer.style.display = isChequeOpted ? "block" : "none";
            }
            if (isChequeOpted) {
                setTimeout(() => {
                    const card = document.getElementById("wizChequePreviewCard");
                    if (card) {
                        card.classList.remove("flipped");
                        card.classList.add("interactive");
                        card.style.transform = "perspective(1000px) rotateX(0deg) rotateY(0deg) scale3d(1, 1, 1)";
                        applyCardTiltEffect("wizChequePreviewCard");
                    }
                }, 100);
            }
        }

        // Handle type / holding selection in Step 1 to dynamically switch flows
        function toggleClassificationFlowSelection() {
            const type = document.getElementById("wizAccountType").value;
            const holding = document.getElementById("wizHoldingType").value;
            
            if (type === "current") {
                activeFlow = "current";
                document.getElementById("wizHoldingTypeWrapper").style.display = "none";
                document.getElementById("wizHeaderTitle").innerText = "Onboard Corporate Business Account";
                
                // ATM Card Options
                document.getElementById("wizPassbookCheckboxWrapper").style.display = "none";
            } else {
                document.getElementById("wizHoldingTypeWrapper").style.display = "block";
                document.getElementById("wizPassbookCheckboxWrapper").style.display = "block";
                
                if (holding === "joint") {
                    activeFlow = "savings_joint";
                    document.getElementById("wizHeaderTitle").innerText = "Onboard Joint Savings Account";
                } else {
                    activeFlow = "savings_single";
                    document.getElementById("wizHeaderTitle").innerText = "Onboard Single Savings Account";
                }
            }

            // Sync visual indicators
            renderStepIndicators();
        }

        // Render step indicators dynamically in wizard header based on active flow
        function renderStepIndicators() {
            const container = document.getElementById("wizardStepsIndicator");
            container.innerHTML = "";
            const steps = wizardFlows[activeFlow];
            
            steps.forEach((step, idx) => {
                const item = document.createElement("div");
                
                let stateClass = "";
                let colorStyle = "color: var(--gray-400);";
                let circleBg = "background: var(--gray-200); color: var(--gray-500);";
                
                if (idx < currentStepIndex) {
                    stateClass = "completed";
                    colorStyle = "color: #10b981;";
                    circleBg = "background: #10b981; color: white;";
                } else if (idx === currentStepIndex) {
                    stateClass = "active";
                    colorStyle = "color: var(--primary-500); font-weight: bold;";
                    circleBg = "background: var(--primary-500); color: white; box-shadow: 0 0 8px rgba(99,102,241,0.25);";
                }
                
                item.style = `display: flex; align-items: center; gap: 6px; font-size: 0.72rem; ${colorStyle}`;
                item.className = `step-indicator-item ${stateClass}`;
                
                item.innerHTML = `
                    <span style="width: 20px; height: 20px; border-radius: 50%; ${circleBg} display: flex; align-items: center; justify-content: center; font-size: 0.65rem; font-weight: 700;">${idx + 1}</span>
                    <span>${step.title}</span>
                `;
                container.appendChild(item);
            });
        }

        // Render step panes visibility and labels
        function updateWizardDisplay() {
            const steps = wizardFlows[activeFlow];
            const currentStep = steps[currentStepIndex];

            // Hide all wizard step panes
            const panes = document.querySelectorAll(".wizard-step-pane");
            panes.forEach(pane => pane.classList.remove("active"));
            
            // Show current active wizard step pane
            document.getElementById(currentStep.id).classList.add("active");

            // Setup boundary configurations inside specific steps
            if (currentStep.id === "wizardStepFunding") {
                const depInput = document.getElementById("wizInitialDeposit");
                if (activeFlow === "current") {
                    document.getElementById("wizMinDepositLabel").innerText = "₹5,000.00 Minimum Fixed Amount";
                    depInput.value = "5000";
                    depInput.min = "5000";
                } else {
                    document.getElementById("wizMinDepositLabel").innerText = "₹1,000.00 Minimum Fixed Amount";
                    depInput.value = "1000";
                    depInput.min = "1000";
                }
            }

            // Sync visual indicators
            renderStepIndicators();

            // Toggle back button
            document.getElementById("wizBackBtn").style.display = currentStepIndex === 0 ? "none" : "inline-block";
            
            // Toggle next/submit button
            if (currentStepIndex === steps.length - 1) {
                document.getElementById("wizNextBtn").style.display = "none";
                document.getElementById("wizSubmitBtn").style.display = "inline-block";
            } else {
                document.getElementById("wizNextBtn").style.display = "inline-block";
                document.getElementById("wizSubmitBtn").style.display = "none";
            }
        }

        // Progress or back navigation within active flow
        function navigateWizardStep(direction) {
            const steps = wizardFlows[activeFlow];
            
            if (direction === 1) {
                // Validate current step before advancing
                if (!validateWizardStepPane()) {
                    return;
                }
            }

            // Advance index
            currentStepIndex += direction;
            if (currentStepIndex < 0) currentStepIndex = 0;
            if (currentStepIndex >= steps.length) currentStepIndex = steps.length - 1;
            
            // If moving to Summary page, render it dynamically
            if (steps[currentStepIndex].id === "wizardStepSummary") {
                renderWizardSummary();
            }

            updateWizardDisplay();
        }

        // Validate the active step pane inputs
        function validateWizardStepPane() {
            const steps = wizardFlows[activeFlow];
            const currentStepId = steps[currentStepIndex].id;

            if (currentStepId === "wizardStepPrimaryHolder") {
                const first = document.getElementById("wizFirstName").value.trim();
                const last = document.getElementById("wizLastName").value.trim();
                const email = document.getElementById("wizEmail").value.trim();
                const phone = document.getElementById("wizPhoneNo").value.trim();
                const address = document.getElementById("wizAddress").value.trim();
                const city = document.getElementById("wizCity").value.trim();
                const state = document.getElementById("wizState").value.trim();
                const zip = document.getElementById("wizZipCode").value.trim();
                const pan = document.getElementById("wizPanCard").value.trim();
                const aadhaar = document.getElementById("wizAadhaarCard").value.trim();

                if (!first || !last || !email || !phone || !address || !city || !state || !zip || !pan || !aadhaar) {
                    alert("Please fill in all primary holder demographic fields marked with an asterisk (*).");
                    return false;
                }

                if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                    alert("Primary Email signature format is invalid.");
                    return false;
                }

                if (phone.length !== 10 || !/^\d+$/.test(phone)) {
                    alert("Primary Phone signature must be exactly 10 numeric digits.");
                    return false;
                }

                if (aadhaar.length !== 12 || !/^\d+$/.test(aadhaar)) {
                    alert("Primary Aadhaar ID number must be exactly 12 numeric digits.");
                    return false;
                }
            }
            else if (currentStepId === "wizardStepJointHolder") {
                const mode = document.getElementById("wizJointCustomerMode").value;
                if (mode === "existing") {
                    const existingId = document.getElementById("wizJointCustomerId").value;
                    if (!existingId) {
                        alert("Please select an existing customer signatory.");
                        return false;
                    }
                } else {
                    const first = document.getElementById("wizJointFirstName").value.trim();
                    const last = document.getElementById("wizJointLastName").value.trim();
                    const email = document.getElementById("wizJointEmail").value.trim();
                    const phone = document.getElementById("wizJointPhone").value.trim();
                    const address = document.getElementById("wizJointAddress").value.trim();
                    const city = document.getElementById("wizJointCity").value.trim();
                    const state = document.getElementById("wizJointState").value.trim();
                    const zip = document.getElementById("wizJointZipCode").value.trim();
                    const pan = document.getElementById("wizJointPan").value.trim();
                    const aadhaar = document.getElementById("wizJointAadhaar").value.trim();

                    if (!first || !last || !email || !phone || !address || !city || !state || !zip || !pan || !aadhaar) {
                        alert("Please fill in all joint holder demographic fields marked with an asterisk (*).");
                        return false;
                    }

                    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                        alert("Joint Email signature format is invalid.");
                        return false;
                    }

                    if (phone.length !== 10 || !/^\d+$/.test(phone)) {
                        alert("Joint Phone signature must be exactly 10 numeric digits.");
                        return false;
                    }

                    if (aadhaar.length !== 12 || !/^\d+$/.test(aadhaar)) {
                        alert("Joint Aadhaar ID number must be exactly 12 numeric digits.");
                        return false;
                    }
                }
            }
            else if (currentStepId === "wizardStepCompanyDetails") {
                const name = document.getElementById("wizBusinessName").value.trim();
                const gstin = document.getElementById("wizGstin").value.trim();
                const phone = document.getElementById("wizCompanyPhone").value.trim();
                const email = document.getElementById("wizCompanyEmail").value.trim();
                const address = document.getElementById("wizCompanyAddress").value.trim();
                const pan = document.getElementById("wizCompanyPan").value.trim();
                const aadhaar = document.getElementById("wizCompanyAadhaar").value.trim();

                if (!name || !gstin || !phone || !email || !address || !pan || !aadhaar) {
                    alert("Please fill in all company information fields marked with an asterisk (*).");
                    return false;
                }
            }
            else if (currentStepId === "wizardStepPartnerDetails") {
                // Verify dynamically added partner cards
                const pFirsts = document.getElementsByName("partnerFirstName");
                const pLasts = document.getElementsByName("partnerLastName");
                const pEmails = document.getElementsByName("partnerEmail");
                const pPhones = document.getElementsByName("partnerPhone");
                const pPans = document.getElementsByName("partnerPan");
                const pAadhaars = document.getElementsByName("partnerAadhaar");

                for (let i = 0; i < pFirsts.length; i++) {
                    const first = pFirsts[i].value.trim();
                    const last = pLasts[i].value.trim();
                    const email = pEmails[i].value.trim();
                    const phone = pPhones[i].value.trim();
                    const pan = pPans[i].value.trim();
                    const aadhaar = pAadhaars[i].value.trim();

                    if (!first || !last || !email || !phone || !pan || !aadhaar) {
                        alert(`Please complete all signatory inputs inside Partner card #${i + 1}.`);
                        return false;
                    }
                    if (phone.length !== 10 || !/^\d+$/.test(phone)) {
                        alert(`Phone signature inside Partner card #${i + 1} must be exactly 10 digits.`);
                        return false;
                    }
                    if (aadhaar.length !== 12 || !/^\d+$/.test(aadhaar)) {
                        alert(`Aadhaar identification inside Partner card #${i + 1} must be exactly 12 digits.`);
                        return false;
                    }
                }
            }
            else if (currentStepId === "wizardStepCredentials") {
                const user = document.getElementById("wizUsername").value.trim();
                const pass = document.getElementById("wizPassword").value;

                if (!user || !pass) {
                    alert("Secure Username and Password credentials are required.");
                    return false;
                }

                if (pass.length < 8 || !/[A-Z]/.test(pass) || !/[a-z]/.test(pass) || !/\d/.test(pass) || !/[^A-Za-z0-9]/.test(pass)) {
                    alert("Secure login password must be at least 8 characters long, containing uppercase, lowercase, numbers, and special characters.");
                    return false;
                }
            }
            else if (currentStepId === "wizardStepFunding") {
                const deposit = parseFloat(document.getElementById("wizInitialDeposit").value);
                const minVal = activeFlow === "current" ? 5000 : 1000;
                
                if (isNaN(deposit) || deposit < minVal) {
                    alert(`Onboarding deposit payment declines: Deposit must be a minimum of ₹${minVal.toLocaleString('en-IN', {minimumFractionDigits: 2})}.`);
                    return false;
                }
            }

            return true;
        }

        // Add dynamic Partner signatories card inside Step 3
        let partnerCount = 0;
        function addPartnerCard() {
            partnerCount++;
            const container = document.getElementById("partnerListContainer");
            const card = document.createElement("div");
            card.className = "partner-card";
            card.id = `partnerCard_${partnerCount}`;
            card.style = "background: rgba(99, 102, 241, 0.02); border: 1px dashed rgba(99, 102, 241, 0.15); padding: 15px; border-radius: var(--radius-md); margin-bottom: 15px; position: relative;";
            card.innerHTML = `
                <button type="button" onclick="removePartnerCard(${partnerCount})" style="position: absolute; right: 10px; top: 10px; background: none; border: none; color: #ef4444; cursor: pointer; font-size: 1.25rem;"><i class="bx bx-trash"></i></button>
                <h5 style="font-size: 0.8rem; font-weight: 700; color: var(--primary-500); margin-bottom: 12px; text-transform: uppercase;">Partner signatory #${partnerCount}</h5>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px 15px;">
                    <div class="form-group">
                        <label class="form-label">First Name *</label>
                        <input type="text" name="partnerFirstName" class="form-control" placeholder="First Name" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Last Name *</label>
                        <input type="text" name="partnerLastName" class="form-control" placeholder="Last Name" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Email Signature *</label>
                        <input type="email" name="partnerEmail" class="form-control" placeholder="partner@company.com" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Phone Signature *</label>
                        <input type="text" name="partnerPhone" class="form-control" placeholder="10 Digits" maxlength="10" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">PAN Card *</label>
                        <input type="text" name="partnerPan" class="form-control" placeholder="ABCDE1234F" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Aadhaar (12 Digits) *</label>
                        <input type="text" name="partnerAadhaar" class="form-control" placeholder="12 Digits" maxlength="12" required>
                    </div>
                </div>
            `;
            container.appendChild(card);
        }

        function removePartnerCard(id) {
            const card = document.getElementById(`partnerCard_${id}`);
            if (card) {
                card.remove();
            }
        }

        // Render wizard summary dynamically in Step 7 review panel
        function renderWizardSummary() {
            const container = document.getElementById("wizardSummaryContainer");
            container.innerHTML = "";

            let html = "";
            
            // Section 1: Classification
            const accType = document.getElementById("wizAccountType").value;
            const holding = document.getElementById("wizHoldingType").value;
            const flowName = activeFlow === "current" ? "Business Current" : `Savings (${holding})`;
            
            html += `
                <div class="summary-card" style="border-left: 4px solid var(--primary-500);">
                    <h5>Onboarding Classification</h5>
                    <div class="summary-grid">
                        <div class="summary-field">
                            <span>Account Type</span>
                            <strong>${flowName}</strong>
                        </div>
                        <div class="summary-field">
                            <span>IFSC Branch Route</span>
                            <strong>${document.getElementById("wizIfscCode").value}</strong>
                        </div>
                    </div>
                </div>
            `;

            // Section 2: Profiles
            if (activeFlow === "current") {
                // Business Details
                html += `
                    <div class="summary-card">
                        <h5>Corporate Company Profile</h5>
                        <div class="summary-grid">
                            <div class="summary-field">
                                <span>Company Name</span>
                                <strong>${document.getElementById("wizBusinessName").value}</strong>
                            </div>
                            <div class="summary-field">
                                <span>GSTIN Code</span>
                                <strong>${document.getElementById("wizGstin").value}</strong>
                            </div>
                            <div class="summary-field">
                                <span>Corporate Phone</span>
                                <strong>${document.getElementById("wizCompanyPhone").value}</strong>
                            </div>
                            <div class="summary-field">
                                <span>Corporate Email</span>
                                <strong>${document.getElementById("wizCompanyEmail").value}</strong>
                            </div>
                            <div class="summary-field">
                                <span>Overdraft Limit</span>
                                <strong>₹${parseFloat(document.getElementById("wizOverdraftLimit").value).toLocaleString('en-IN', {minimumFractionDigits: 2})}</strong>
                            </div>
                        </div>
                    </div>
                `;

                // Partners summary
                const pFirsts = document.getElementsByName("partnerFirstName");
                const pLasts = document.getElementsByName("partnerLastName");
                if (pFirsts.length > 0) {
                    html += `
                        <div class="summary-card">
                            <h5>Partner Signatories (${pFirsts.length})</h5>
                            <div class="summary-grid">
                    `;
                    for (let i = 0; i < pFirsts.length; i++) {
                        html += `
                            <div class="summary-field">
                                <span>Partner #${i+1}</span>
                                <strong>${pFirsts[i].value} ${pLasts[i].value}</strong>
                            </div>
                        `;
                    }
                    html += `
                            </div>
                        </div>
                    `;
                }
            } else {
                // Primary Holder
                html += `
                    <div class="summary-card">
                        <h5>Primary Holder Personal Details</h5>
                        <div class="summary-grid">
                            <div class="summary-field">
                                <span>Full Name</span>
                                <strong>${document.getElementById("wizFirstName").value} ${document.getElementById("wizLastName").value}</strong>
                            </div>
                            <div class="summary-field">
                                <span>Email signature</span>
                                <strong>${document.getElementById("wizEmail").value}</strong>
                            </div>
                            <div class="summary-field">
                                <span>Phone signature</span>
                                <strong>${document.getElementById("wizPhoneNo").value}</strong>
                            </div>
                            <div class="summary-field">
                                <span>PAN Card</span>
                                <strong>${document.getElementById("wizPanCard").value}</strong>
                            </div>
                            <div class="summary-field">
                                <span>Aadhaar Ident</span>
                                <strong>${document.getElementById("wizAadhaarCard").value}</strong>
                            </div>
                        </div>
                    </div>
                `;

                // Joint Holder
                if (activeFlow === "savings_joint") {
                    const mode = document.getElementById("wizJointCustomerMode").value;
                    let jointName = "";
                    if (mode === "existing") {
                        const sel = document.getElementById("wizJointCustomerId");
                        jointName = sel.options[sel.selectedIndex].text;
                    } else {
                        jointName = `${document.getElementById("wizJointFirstName").value} ${document.getElementById("wizJointLastName").value} (Brand New Profile)`;
                    }

                    html += `
                        <div class="summary-card">
                            <h5>Joint Holder Signatory Details</h5>
                            <div class="summary-grid">
                                <div class="summary-field">
                                    <span>Holding Signee</span>
                                    <strong>${jointName}</strong>
                                </div>
                            </div>
                        </div>
                    `;
                }

                // Nominee Details
                const nominee = document.getElementById("wizNomineeName").value.trim();
                html += `
                    <div class="summary-card">
                        <h5>Nominee configuration</h5>
                        <div class="summary-grid">
                            <div class="summary-field">
                                <span>Nominee Name</span>
                                <strong>${nominee || "No Nominee Registered"}</strong>
                            </div>
                            <div class="summary-field">
                                <span>Daily ATM Limit</span>
                                <strong>₹${parseFloat(document.getElementById("wizDailyWithdrawalLimit").value).toLocaleString('en-IN', {minimumFractionDigits: 2})}</strong>
                            </div>
                        </div>
                    </div>
                `;
            }

            // Section 3: preferences & credentials
            const hasAtm = document.getElementById("wizHasAtmCard").checked;
            const hasCheque = document.getElementById("wizHasChequeBook").checked;
            
            let services = [];
            if (hasAtm) services.push("ATM Debit Card");
            if (hasCheque) services.push("Cheque Book");
            if (activeFlow !== "current") services.push("Passbook (Default selected)");

            html += `
                <div class="summary-card">
                    <h5>Onboarding preferences & credentials</h5>
                    <div class="summary-grid">
                        <div class="summary-field">
                            <span>Services approved</span>
                            <strong>${services.join(", ") || "None"}</strong>
                        </div>
                        <div class="summary-field">
                            <span>Login Username</span>
                            <strong>${document.getElementById("wizUsername").value}</strong>
                        </div>
                        <div class="summary-field" style="color: var(--accent-emerald);">
                            <span>Auto-Generated PIN</span>
                            <strong>${document.getElementById("wizPin").value}</strong>
                        </div>
                    </div>
                </div>
            `;

            // Section 4: deposit
            const deposit = parseFloat(document.getElementById("wizInitialDeposit").value);
            html += `
                <div class="summary-card" style="border-left: 4px solid var(--accent-emerald);">
                    <h5>Initial Funding Ledger</h5>
                    <div class="summary-grid">
                        <div class="summary-field">
                            <span>Initial Deposit Credit</span>
                            <strong style="color: var(--accent-emerald); font-size: 1.1rem;">₹${deposit.toLocaleString('en-IN', {minimumFractionDigits: 2})}</strong>
                        </div>
                    </div>
                </div>
            `;

            container.innerHTML = html;
        }

        // Intercept final submission to verify funding
        document.getElementById("createAccountForm").addEventListener("submit", function(e) {
            const deposit = parseFloat(document.getElementById("wizInitialDeposit").value);
            const minVal = activeFlow === "current" ? 5000 : 1000;
            
            if (isNaN(deposit) || deposit < minVal) {
                alert(`Onboarding deposit payment declines: Deposit must be a minimum of ₹${minVal.toLocaleString('en-IN', {minimumFractionDigits: 2})}.`);
                e.preventDefault();
            }
        });

        // Apply 3D tilt effect to a card wrapper
        function applyCardTiltEffect(wrapperId) {
            const wrapper = document.getElementById(wrapperId);
            if (!wrapper) return;
            
            wrapper.addEventListener('mousemove', function(e) {
                const rect = wrapper.getBoundingClientRect();
                const x = e.clientX - rect.left;
                const y = e.clientY - rect.top;
                
                const width = rect.width;
                const height = rect.height;
                
                const percentX = (x / width) - 0.5;
                const percentY = (y / height) - 0.5;
                
                const maxRotation = 12;
                
                const rotateX = -(percentY * maxRotation).toFixed(2);
                const rotateY = (percentX * maxRotation).toFixed(2);
                
                wrapper.style.transform = `perspective(1000px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) scale3d(1.03, 1.03, 1.03)`;
            });
            
            wrapper.addEventListener('mouseleave', function() {
                wrapper.style.transition = "transform 0.5s cubic-bezier(0.4, 0, 0.2, 1)";
                wrapper.style.transform = "perspective(1000px) rotateX(0deg) rotateY(0deg) scale3d(1, 1, 1)";
            });
            
            wrapper.addEventListener('mouseenter', function() {
                wrapper.style.transition = "none";
            });
        }

        // Show 3D card preview for ATM card option in preferences step
        function showWizAtmCardPreview() {
            const wrapper = document.getElementById('wizAtmTiltWrapper');
            const card = document.getElementById('wizAtmPreviewCard');
            
            if (wrapper && card) {
                card.classList.remove('flipped');
                card.classList.add('interactive');
                wrapper.style.transform = "perspective(1000px) rotateX(0deg) rotateY(0deg) scale3d(1, 1, 1)";
                applyCardTiltEffect('wizAtmTiltWrapper');
            }
        }

        // Flip the wizard ATM card preview
        function flipWizAtmCard() {
            const card = document.getElementById("wizAtmPreviewCard");
            if (card) {
                card.classList.toggle("flipped");
            }
        }

        // Flip generic 3D service card previews (cheque book, passbook)
        function flipWizServiceCard(cardId) {
            const card = document.getElementById(cardId);
            if (card) {
                card.classList.toggle("flipped");
            }
        }

        // Sync wizard ATM card preview with control selections
        function syncWizAtmCardPreview() {
            const card = document.getElementById('wizAtmPreviewCard');
            const typeSelect = document.getElementById('wizCardType');
            const providerSelect = document.getElementById('wizCardProvider');

            if (!card || !typeSelect || !providerSelect) return;

            const type = typeSelect.value;
            const provider = providerSelect.value;
            const hasAtm = document.getElementById('wizHasAtmCard').checked;

            // Update provider label
            document.getElementById('wizProviderLabel').innerText = provider.toUpperCase();

            // Set card background based on type
            card.className = "vgb-atm-card";
            if (type === 'credit') {
                card.classList.add('credit');
            } else {
                card.classList.add('debit');
            }

            // Generate demo card number based on provider prefix
            let cardPrefix = "4"; // Visa
            if (provider === 'mastercard') cardPrefix = "5";
            if (provider === 'rupay') cardPrefix = "6";

            // Generate random number if not already set or for demo
            let number = "4589 7321 6048 2190";
            document.getElementById('wizNumberLabel').innerText = number;
            document.getElementById('wizHolderLabel').innerText = hasAtm ? "NEW ACCOUNT" : "DEMO HOLDER";
        }

        // Mask/Unmask CVV on the back face securely without flipping card
        function toggle3DCardCvv(event, element) {
            if (event) event.stopPropagation();
            const realCvv = element.getAttribute('data-cvv') || "907";
            if (element.innerText === '•••') {
                element.innerText = realCvv;
                element.title = "Click to hide CVV";
            } else {
                element.innerText = '•••';
                element.title = "Click to show CVV";
            }
        }

        // Initialize card preview when preferences step is shown
        document.addEventListener("DOMContentLoaded", function() {
            const observer = new MutationObserver(function(mutations) {
                mutations.forEach(function(mutation) {
                    if (mutation.type === "attributes" && mutation.attributeName === "class") {
                        const pane = mutation.target;
                        if (pane.id === "wizardStepPreferences" && pane.classList.contains("active")) {
                            setTimeout(showWizAtmCardPreview, 100);
                            const isChequeOpted = document.getElementById("wizHasChequeBook") && document.getElementById("wizHasChequeBook").checked;
                            if (isChequeOpted) {
                                setTimeout(function() {
                                    const chequeCard = document.getElementById("wizChequePreviewCard");
                                    if (chequeCard) {
                                        chequeCard.classList.remove("flipped");
                                        chequeCard.classList.add("interactive");
                                        chequeCard.style.transform = "perspective(1000px) rotateX(0deg) rotateY(0deg) scale3d(1, 1, 1)";
                                        applyCardTiltEffect("wizChequePreviewCard");
                                    }
                                }, 150);
                            }
                        }
                    }
                });
            });

            const prefsPane = document.getElementById("wizardStepPreferences");
            if (prefsPane) {
                observer.observe(prefsPane, { attributes: true });
            }
        });
            });

            const prefsPane = document.getElementById('wizardStepPreferences');
            if (prefsPane) {
                observer.observe(prefsPane, { attributes: true });
            }
        });
