
document.addEventListener('DOMContentLoaded', () => {
    // --- Login Logic ---
    // Codes d'accès autorisés
    const accessCodes = [
        "admin", "etudiant1", "etudiant2", "flavio", "cisco2026", "cricri"
    ];

    const overlay = document.getElementById('login-overlay');
    const input = document.getElementById('access-code');
    const errorMsg = document.getElementById('error-msg');
    const btn = document.querySelector('.login-box button');

    // Check if valid user session exists
    const currentUser = localStorage.getItem('current_user');
    
    // Only hide overlay if user is logged in
    if (currentUser && accessCodes.includes(currentUser)) {
        if(overlay) overlay.classList.add('hidden');
        showUserInterface(currentUser);
    }

    window.checkAccess = function() {
        const val = input.value.trim();
        if (accessCodes.includes(val)) {
            localStorage.setItem('current_user', val);
            if(overlay) overlay.classList.add('hidden');
            showUserInterface(val);
        } else {
            if(errorMsg) errorMsg.style.display = 'block';
            if(input) {
                input.style.borderColor = '#dc3545';
                input.value = '';
                input.focus();
            }
        }
    };

    window.logout = function() {
        localStorage.removeItem('current_user');
        location.reload();
    };

    function showUserInterface(username) {
        const welcomeDiv = document.getElementById('user-welcome');
        const skillsDiv = document.getElementById('skills-container');
        const userSpan = document.getElementById('current-user');
        
        if (welcomeDiv) welcomeDiv.classList.remove('hidden');
        if (skillsDiv) skillsDiv.classList.remove('hidden');
        if (userSpan) userSpan.textContent = username;
        
        loadHistory(username);
    }

    function loadHistory(username) {
        const grid = document.getElementById('history-grid');
        if (!grid) return;
        
        const key = `history_${username}`;
        const raw = localStorage.getItem(key);
        let history = [];
        
        try {
            history = raw ? JSON.parse(raw) : [];
        } catch(e) { history = []; }
        
        if (history.length === 0) {
            grid.innerHTML = '<p style="grid-column: 1/-1; color:#666; font-style:italic;">Aucun résultat enregistré pour cet utilisateur.</p>';
            return;
        }
        
        // Sort by date desc
        history.sort((a,b) => new Date(b.date) - new Date(a.date));
        
        let html = '';
        history.forEach(item => {
            const ratio = item.score / item.total;
            let scoreClass = 'score-bad';
            if (ratio === 1) scoreClass = 'score-perfect';
            else if (ratio >= 0.8) scoreClass = 'score-good';
            else if (ratio >= 0.5) scoreClass = 'score-average';
            
            const dateStr = new Date(item.date).toLocaleString();
            
            html += `
            <div class="history-card">
                <h4>
                    <span><i class="fas fa-list-ol"></i> Série ${item.seriesId}</span>
                    <span class="${scoreClass}"><i class="fas fa-star"></i> ${item.score}/${item.total}</span>
                </h4>
                <span class="history-date"><i class="far fa-clock"></i> ${dateStr}</span>
            </div>
            `;
        });
        
        grid.innerHTML = html;
    }
    
    function saveResult(username, seriesId, score, total) {
        const key = `history_${username}`;
        const raw = localStorage.getItem(key);
        let history = [];
        try { history = raw ? JSON.parse(raw) : []; } catch(e) {}
        
        history.push({
            seriesId: seriesId,
            score: score,
            total: total,
            date: new Date().toISOString()
        });
        
        localStorage.setItem(key, JSON.stringify(history));
        // Refresh display
        loadHistory(username);
    }

    // Attach event listener to button if it exists
    if(btn) {
        btn.onclick = window.checkAccess;
    }

    // Allow Enter key
    window.handleLogin = function(e) {
        if (e.key === 'Enter') {
            window.checkAccess();
        }
    };
    
    // Focus input on load
    if (input && (!sessionStorage.getItem('is_authenticated'))) {
        setTimeout(() => input.focus(), 500);
    }
    // --- End Login Logic ---

    // Variable to hold all questions grouped by series
    let quizChunks = {};
    let totalSeries = 0;
    let currentSeriesId = 1;

    // Fetch questions from JSON or use global variable
    if (typeof allQuestions !== 'undefined') {
         processQuestions(allQuestions);
         initMenu();
    } else if (typeof quizData !== 'undefined' && Array.isArray(quizData) && quizData.length > 0) {
        // Fallback for older variable name
        processQuestions(quizData);
        initMenu();
    } else {
        fetch('questions.json')
            .then(response => {
                if (!response.ok) {
                    throw new Error("HTTP error " + response.status);
                }
                return response.json();
            })
            .then(data => {
                processQuestions(data);
                initMenu();
            })
            .catch(err => {
                console.error('Error loading questions:', err);
                const container = document.querySelector('.container');
                if (container) {
                    const errorMsg = document.createElement('div');
                    errorMsg.style.color = 'red';
                    errorMsg.style.textAlign = 'center';
                    errorMsg.style.padding = '20px';
                    errorMsg.innerHTML = `<strong>Erreur de chargement des questions.</strong><br>${err.message}`;
                    container.prepend(errorMsg);
                }
            });
    }

    function processQuestions(allQuestions) {
        // Group questions into chunks of 10
        const chunkSize = 10;
        let seriesIndex = 1;
        
        for (let i = 0; i < allQuestions.length; i += chunkSize) {
            const chunk = allQuestions.slice(i, i + chunkSize);
            quizChunks[seriesIndex] = chunk;
            seriesIndex++;
        }
        totalSeries = seriesIndex - 1;
    }

    function initMenu() {
        const menuContainer = document.querySelector('#menu-container .series-grid');
        if (!menuContainer) return;
        
        menuContainer.innerHTML = '';
        
        for (let i = 1; i <= totalSeries; i++) {
            const btn = document.createElement('button');
            btn.className = 'btn-series';
            btn.innerHTML = `<i class="fas fa-list-ol"></i> Série ${i}<br><span style="font-size:0.8em">10 Questions</span>`;
            
            // Capture index in closure
            (function(idx) {
                btn.onclick = () => startQuiz(idx);
            })(i);
            
            menuContainer.appendChild(btn);
        }
    }

    // --- Quiz Logic ---
    window.startQuiz = function(seriesId) {
        currentSeriesId = seriesId;
        
        const menu = document.getElementById('menu-container');
        const quizForm = document.getElementById('quiz-form');
        
        if (menu) menu.classList.add('hidden');
        if (quizForm) quizForm.classList.remove('hidden');
        
        // Update Title
        const titleEl = document.querySelector('header h1'); 
        // Keep main title but append series info? Or just show series.
        // Let's replace temporarily
        // Actually better to have a dedicated title area in quiz form if needed.
        
        // Reset previous results
        const resArea = document.getElementById('result-area');
        if (resArea) resArea.classList.add('hidden');
        
        renderQuestions(seriesId);
        window.scrollTo({ top: 0, behavior: 'smooth' });
    };

    window.showMenu = function() {
        const menu = document.getElementById('menu-container');
        const quizForm = document.getElementById('quiz-form');
        
        if (quizForm) quizForm.classList.add('hidden');
        if (menu) menu.classList.remove('hidden');
        
        const qContainer = document.getElementById('questions-container');
        if (qContainer) qContainer.innerHTML = '';
    };

    function renderQuestions(seriesId) {
        const container = document.getElementById('questions-container');
        if (!container) return;

        container.innerHTML = '';

        const questions = quizChunks[seriesId];

        if (!questions) {
            container.innerHTML = '<p>Série non disponible.</p>';
            return;
        }

        questions.forEach((q, index) => {
            const qNum = q.id;
            const uniqueName = `q-${seriesId}-${index}`;

            const card = document.createElement('div');
            card.className = 'question-card';
            // Store correct index as string or JSON array
            card.dataset.correct = JSON.stringify(q.correct);
            
            // Determine input type (radio or checkbox)
            const inputType = (q.correct && q.correct.length > 1) ? 'checkbox' : 'radio';
            const instructionText = (inputType === 'checkbox') ? '<small style="color:#666; display:block; margin-bottom:5px;">(Plusieurs choix possibles)</small>' : '';

            // Image handling
            let imgHtml = '';
            if (q.image && q.image.trim() !== "") {
                imgHtml = `<div class="q-image" style="margin: 10px 0;">
                    <img src="${q.image}" alt="Illustration Question ${q.id}" style="max-width:100%; height:auto; border:1px solid #ddd; border-radius:4px; display:block; margin:0 auto;">
                </div>`;
            }

            // Options handling
            let optionsHtml = '';
            if (q.options && q.options.length > 0) {
                q.options.forEach((optText, optIdx) => {
                    optionsHtml += `
                        <label class="option" data-idx="${optIdx}" style="display:block; margin-bottom:8px; padding:10px; border:1px solid #eee; border-radius:4px; cursor:pointer;">
                            <input type="${inputType}" name="${uniqueName}" value="${optIdx}" style="margin-right:10px;">
                            <span class="opt-text">${optText}</span>
                        </label>
                    `;
                });
            } else {
                optionsHtml = '<p style="color:#666; font-style:italic; padding:10px;">(Pas d\'options détectées pour cette question. La réponse est probablement dans l\'énoncé ou l\'image.)</p>';
            }

            // Explanation Section (Hidden by default)
            let explanationHtml = '';
            if (q.explanation && q.explanation.trim() !== "") {
                explanationHtml = `
                    <div class="explanation hidden" style="margin-top:15px; padding:10px; background:#e8f5e9; border-left:4px solid #4caf50; border-radius:4px; color:#333;">
                        <strong><i class="fas fa-info-circle"></i> Explication:</strong><br>
                        ${q.explanation}
                    </div>
                `;
            }

            card.innerHTML = `
                <div class="question-header" style="margin-bottom:15px;">
                    <span class="q-number" style="font-weight:bold; color:#0056b3;">Q${qNum}.</span>
                    <div style="margin-top:5px;">
                        <h4 style="margin:0 0 10px 0; color:#333;">${q.question}</h4>
                        ${imgHtml}
                    </div>
                </div>
                <div class="options-list">
                    ${optionsHtml}
                </div>
                ${explanationHtml}
            `;
            container.appendChild(card);
        });
        
        // Re-bind submit button
        const submitBtn = document.getElementById('submit-btn');
        if (submitBtn) {
            // Clone to remove old listeners
            const newBtn = submitBtn.cloneNode(true);
            submitBtn.parentNode.replaceChild(newBtn, submitBtn);
            
            newBtn.addEventListener('click', validateQuiz);
        }
    }

    function validateQuiz() {
        let score = 0;
        // Re-query cards to be safe (though scope is fine)
        const cards = document.querySelectorAll('.question-card');
        const questionsTotal = cards.length;
        
        cards.forEach(card => {
            let correctIndices = [];
            try {
                const raw = JSON.parse(card.dataset.correct);
                if (Array.isArray(raw)) correctIndices = raw;
                else correctIndices = [raw];
            } catch(e) {
                // fallback single int
                correctIndices = [parseInt(card.dataset.correct)];
            }
            // Remove -1 from correct indices (meaning no answer found)
            correctIndices = correctIndices.filter(i => i !== -1);
            
            const options = card.querySelectorAll('.option');
            let userCorrectCount = 0;
            let userWrongCount = 0;
            let userTotalSelected = 0;
            
            // 1. Reset
            options.forEach(opt => {
                opt.style.backgroundColor = '';
                opt.style.fontWeight = 'normal';
            });
            const expl = card.querySelector('.explanation');
            if (expl) expl.classList.add('hidden');
            
            // 2. Check each option
            options.forEach(opt => {
                const inp = opt.querySelector('input');
                const val = parseInt(inp.value);
                const isChecked = inp.checked;
                const isAnswer = correctIndices.includes(val);
                
                if (isChecked) {
                    userTotalSelected++;
                    if (isAnswer) {
                        opt.style.backgroundColor = '#d4edda'; // Green for correct selected
                        userCorrectCount++;
                    } else {
                        opt.style.backgroundColor = '#f8d7da'; // Red for wrong selected
                        userWrongCount++;
                    }
                }
                
                // Always show correct answers
                if (isAnswer) {
                    opt.style.fontWeight = 'bold';
                    if (!isChecked) {
                         opt.style.backgroundColor = '#d4edda'; // Light green for missed correct
                         opt.style.opacity = '0.7';
                    }
                }
            });
            
            // Scoring: Strict match. ALL correct must be selected, ZERO wrong.
            // Exception: If question has NO correct answer defined (-1), valid? No.
            if (correctIndices.length > 0 && userWrongCount === 0 && userCorrectCount === correctIndices.length) {
                score++;
            }
            
            if (expl) expl.classList.remove('hidden');
        });

        // Save result
        const currentUser = localStorage.getItem('current_user');
        if (currentUser) {
            saveResult(currentUser, currentSeriesId, score, questionsTotal);
        }

        // Update UI
        const resultArea = document.getElementById('result-area');
        if (resultArea) {
            resultArea.classList.remove('hidden');
            const scoreEl = resultArea.querySelector('#score-val');
            const totalEl = resultArea.querySelector('#total-val');
            if(scoreEl) scoreEl.textContent = score;
            if(totalEl) totalEl.textContent = questionsTotal;
            
            const msgProps = getFeedbackMessage(score, questionsTotal);
            const msgEl = resultArea.querySelector('#result-msg');
            if(msgEl) {
                msgEl.textContent = msgProps.text;
                msgEl.style.color = msgProps.color;
            }
            resultArea.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
    }

    function getFeedbackMessage(score, total) {
        if (total === 0) return { text: "", color: "black" };
        const ratio = score / total;
        if (ratio === 1) return { text: "Excellent ! Un sans faute !", color: "#2e7d32" }; // dark green
        if (ratio >= 0.8) return { text: "Très bien ! Vous maîtrisez le sujet.", color: "#4caf50" }; // green
        if (ratio >= 0.5) return { text: "Pas mal, mais des révisions sont nécessaires.", color: "#ff9800" }; // orange
        return { text: "Attention, il faut revoir le cours.", color: "#f44336" }; // red
    }
});
