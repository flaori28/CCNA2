/**
 * CCNA 2 Exam Trainer - Core Logic v3.0
 * Completely rewritten for stability and performance.
 */

const App = {
    state: {
        questions: [],
        currentSeries: null,
        currentQuestions: [],
        userHistory: [],
        view: 'dashboard'
    },

    init: function() {
        console.log("App Initializing...");
        this.loadData();
        this.loadHistory();
        this.setupNavigation();
        this.renderstats();
    },

    loadData: function() {
        if (typeof allQuestions !== 'undefined' && Array.isArray(allQuestions)) {
            this.state.questions = allQuestions;
            this.renderSeriesList();
        } else {
            console.error("Data source 'allQuestions' not found!");
            document.getElementById('series-list').innerHTML = "<p style='color:red'>Erreur: Données non chargées. Vérifiez quiz_data.js</p>";
        }
    },

    loadHistory: function() {
        const raw = localStorage.getItem('ccna2_history');
        if (raw) {
            try {
                this.state.userHistory = JSON.parse(raw);
            } catch (e) {
                console.warn("History corrupted, resetting.");
                this.state.userHistory = [];
            }
        }
    },

    saveHistory: function(result) {
        this.state.userHistory.push(result);
        localStorage.setItem('ccna2_history', JSON.stringify(this.state.userHistory));
        this.renderstats();
    },

    renderstats: function() {
        const history = this.state.userHistory;
        const totalAttempts = history.length;
        let totalScore = 0;
        let maxScore = 0;
        const uniqueSeries = new Set();
        
        history.forEach(h => {
             totalScore += h.score;
             maxScore += h.total;
             uniqueSeries.add(h.seriesId);
        });

        const avg = maxScore > 0 ? Math.round((totalScore / maxScore) * 100) : 0;
        const seriesCount = Math.ceil(this.state.questions.length / 10);
        const progress = Math.round((uniqueSeries.size / seriesCount) * 100);

        // Header Mini Stats
        const headerStats = document.getElementById('global-stats');
        if (headerStats) headerStats.textContent = `Moyenne: ${avg}% | Complété: ${progress}%`;

        // Dashboard Stats
        const dash = document.getElementById('stats-dashboard');
        if (dash) {
            dash.innerHTML = `
                <div class="stat-metric">
                    <h3>${avg}%</h3>
                    <span>Moyenne</span>
                </div>
                <div class="stat-metric">
                    <h3>${totalAttempts}</h3>
                    <span>Quiz Terminés</span>
                </div>
                <div class="stat-metric">
                    <h3>${uniqueSeries.size} / ${seriesCount}</h3>
                    <span>Séries Uniques</span>
                </div>
            `;
        }
    },

    renderSeriesList: function() {
        const grid = document.getElementById('series-list');
        if (!grid) return;
        grid.innerHTML = '';

        const totalQ = this.state.questions.length;
        const chunkSize = 10;
        const totalSeries = Math.ceil(totalQ / chunkSize);

        for (let i = 1; i <= totalSeries; i++) {
            const btn = document.createElement('div');
            btn.className = 'btn-series';
            
            // Check best score for this series
            const best = this.state.userHistory
                .filter(h => h.seriesId === i)
                .reduce((max, curr) => (curr.score > max ? curr.score : max), -1);
            
            let badge = '';
            if (best >= 0) {
                const color = best >= 8 ? 'green' : (best >= 5 ? 'orange' : 'red');
                badge = `<span style="float:right; color:${color}; font-weight:bold;">${best}/10</span>`;
            }

            btn.innerHTML = `
                <h4>Série ${i} ${badge}</h4>
                <span>Questions ${(i-1)*10 + 1} - ${Math.min(i*10, totalQ)}</span>
            `;
            btn.onclick = () => this.startSeries(i);
            grid.appendChild(btn);
        }
    },

    startSeries: function(id) {
        this.state.currentSeries = id;
        const startIdx = (id - 1) * 10;
        this.state.currentQuestions = this.state.questions.slice(startIdx, startIdx + 10);
        
        this.switchView('quiz');
        document.getElementById('quiz-title').textContent = `Série ${id}`;
        document.getElementById('quiz-progress-text').textContent = `10 Questions`;
        
        this.renderQuizForm();
        window.scrollTo(0,0);
    },

    renderQuizForm: function() {
        const container = document.getElementById('questions-container');
        container.innerHTML = '';

        this.state.currentQuestions.forEach((q, index) => {
            const card = document.createElement('div');
            card.className = 'q-card';
            card.dataset.id = q.id;
            card.dataset.index = index;

            // Header: Question Text & Image
            let html = `<h3>${index+1}. ${q.question}</h3>`;
            if (q.image) {
                html += `<img src="${q.image}" style="max-width:100%; border-radius:4px; margin-bottom:15px;">`;
            }

            // Body: Options or Match
            html += '<div class="q-body">';
            
            if (q.type === 'match' || (q.match_pairs && q.match_pairs.length > 0)) {
                // RENDER MATCH
                html += this.renderMatchQuestion(q, index);
            } else {
                // RENDER STANDARD
                html += this.renderStandardOptions(q, index);
            }
            
            html += '</div>';

            // Footer: Explanation (Hidden)
            if (q.explanation) {
                html += `<div class="explanation-box" id="expl-${index}">${q.explanation}</div>`;
            }

            card.innerHTML = html;
            container.appendChild(card);
        });

        // Re-init Drag & Drop listeners
        this.initDragDrop();
    },

    renderMatchQuestion: function(q, qIndex) {
        let leftRows = '';
        let rightItems = '';
        
        // Prepare Right Items (Shuffle)
        const terms = q.match_pairs.map((p, i) => ({ term: p.term, id: i }));
        terms.sort(() => Math.random() - 0.5);

        q.match_pairs.forEach((pair, idx) => {
            leftRows += `
                <div class="match-row" data-correct-term="${pair.term}">
                    <span>${pair.definition}</span>
                    <div class="target-zone" data-zone-id="${q.id}-${idx}"></div>
                </div>
            `;
        });

        terms.forEach((item, idx) => {
             rightItems += `
                <div class="draggable-item" draggable="true" id="drag-${q.id}-${item.id}" data-term="${item.term}">
                    ${item.term}
                </div>
             `;
        });

        return `
            <div class="match-area">
                <div class="match-rows">${leftRows}</div>
                <div class="draggable-bank" id="bank-${q.id}">${rightItems}</div>
            </div>
        `;
    },

    renderStandardOptions: function(q, qIndex) {
        let html = '<div class="options-list">';
        const isMulti = q.correct && q.correct.length > 1;
        const type = isMulti ? 'checkbox' : 'radio';

        if (!q.options || q.options.length === 0) {
            return '<p><i>Aucune option disponible.</i></p>';
        }

        q.options.forEach((opt, idx) => {
            html += `
                <label class="opt-item">
                    <input type="${type}" name="q-${qIndex}" value="${idx}">
                    ${opt}
                </label>
            `;
        });
        html += '</div>';
        return html;
    },

    validate: function() {
        let score = 0;
        const cards = document.querySelectorAll('.q-card');
        
        cards.forEach(card => {
            const index = parseInt(card.dataset.index);
            const q = this.state.currentQuestions[index];
            let isCorrect = false;

            // Clean previous styles
            card.querySelectorAll('.opt-item').forEach(el => el.classList.remove('correct-highlight', 'wrong-highlight', 'missed-highlight'));
            
            if (q.type === 'match' || (q.match_pairs && q.match_pairs.length > 0)) {
                // Validate Match
                const rows = card.querySelectorAll('.match-row');
                let rowCorrectCount = 0;
                rows.forEach(row => {
                    const target = row.dataset.correctTerm;
                    const zone = row.querySelector('.target-zone');
                    const item = zone.querySelector('.draggable-item');
                    
                    if (item) {
                        if (item.dataset.term === target) {
                            zone.style.borderColor = 'green';
                            zone.style.background = '#d4edda';
                            rowCorrectCount++;
                        } else {
                            zone.style.borderColor = 'red';
                            zone.style.background = '#f8d7da';
                        }
                    } else {
                        zone.style.borderColor = 'orange'; // Missed
                    }
                });
                if (rowCorrectCount === rows.length) isCorrect = true;

            } else {
                // Validate Standard
                const inputs = card.querySelectorAll(`input[name="q-${index}"]`);
                let userSelected = [];
                inputs.forEach(inp => { if (inp.checked) userSelected.push(parseInt(inp.value)); });
                
                const correctIndices = q.correct || [];
                
                // Check Logic
                const correctSet = new Set(correctIndices);
                const userSet = new Set(userSelected);
                
                // Strict equality for score
                if (userSelected.length === correctIndices.length && userSelected.every(v => correctSet.has(v))) {
                    isCorrect = true;
                }

                // Visual Feedback
                inputs.forEach(inp => {
                    const val = parseInt(inp.value);
                    const parent = inp.closest('.opt-item');
                    
                    if (correctSet.has(val)) {
                        parent.classList.add('correct-highlight'); // It was a correct answer
                        if (!userSet.has(val)) parent.classList.add('missed-highlight'); // But user missed it
                    } else if (userSet.has(val)) {
                        parent.classList.add('wrong-highlight'); // User selected wrong
                    }
                });
            }

            if (isCorrect) score++;

            // Show explanation
            const expl = card.querySelector('.explanation-box');
            if (expl) expl.classList.add('visible');
        });

        // Save & Show Result (Wait 500ms for UX)
        setTimeout(() => {
             this.showResults(score, this.state.currentQuestions.length);
        }, 500);
    },

    showResults: function(score, total) {
        this.saveHistory({
            seriesId: this.state.currentSeries,
            score: score,
            total: total,
            date: new Date().toISOString()
        });

        this.switchView('results');
        
        const circle = document.getElementById('score-circle');
        const display = document.getElementById('score-display');
        const msg = document.getElementById('result-message');
        
        const pct = Math.round((score/total)*100);
        display.textContent = `${pct}%`;
        
        // Color
        if (pct === 100) circle.style.background = '#107c10'; // Green
        else if (pct >= 80) circle.style.background = '#2b88d8'; // Blue
        else if (pct >= 50) circle.style.background = '#ffb900'; // Orange
        else circle.style.background = '#d13438'; // Red

        msg.innerHTML = `Vous avez obtenu <b>${score}</b> sur <b>${total}</b>.<br>`;
        if (pct < 50) msg.innerHTML += "N'hésitez pas à revoir le cours.";
        else if (pct < 80) msg.innerHTML += "Bon travail, continuez ainsi !";
        else msg.innerHTML += "Excellent résultat !";
    },

    initDragDrop: function() {
        const draggables = document.querySelectorAll('.draggable-item');
        const dropzones = document.querySelectorAll('.target-zone, .draggable-bank');

        draggables.forEach(d => {
            d.addEventListener('dragstart', (e) => {
                e.dataTransfer.setData('text/plain', e.target.id);
                setTimeout(() => {
                    e.target.style.opacity = '0.5';
                }, 0);
            });
            d.addEventListener('dragend', (e) => {
                e.target.style.opacity = '1';
                e.target.style.display = 'block';
            });
        });

        dropzones.forEach(zone => {
            zone.addEventListener('dragover', (e) => {
                e.preventDefault();
                zone.classList.add('drag-hover');
            });
            
            zone.addEventListener('dragleave', (e) => {
                zone.classList.remove('drag-hover');
            });

            zone.addEventListener('drop', (e) => {
                e.preventDefault();
                zone.classList.remove('drag-hover');
                const id = e.dataTransfer.getData('text/plain');
                const draggable = document.getElementById(id);
                
                if (!draggable) return;

                // Scenario: Dropping into a Target Zone (Answer slot)
                if (zone.classList.contains('target-zone')) {
                    // Check if occupied
                    if (zone.children.length > 0) {
                        // Move existing item back to bank (or swap? let's stick to bank for simplicity)
                        const existing = zone.children[0];
                        const bankId = zone.closest('.match-area').querySelector('.draggable-bank').id;
                        document.getElementById(bankId).appendChild(existing);
                    }
                    zone.appendChild(draggable);
                } 
                // Scenario: Dropping back into Bank
                else if (zone.classList.contains('draggable-bank')) {
                    zone.appendChild(draggable);
                }
                
                draggable.style.opacity = '1';
                draggable.style.display = 'block';
            });
        });
    },

    switchView: function(viewName) {
        document.querySelectorAll('main > section').forEach(el => el.classList.remove('active-view'));
        document.querySelectorAll('main > section').forEach(el => el.classList.add('hidden-view'));
        
        const target = document.getElementById(`view-${viewName}`);
        if(target) {
            target.classList.remove('hidden-view');
            target.classList.add('active-view');
        }
        this.state.view = viewName;
    },
    
    setupNavigation: function() {
        document.getElementById('btn-validate').addEventListener('click', () => this.validate());
    }
};


// Global Helpers
function showDashboard() {
    App.switchView('dashboard');
    App.renderstats(); // refresh
}

function retryCurrentQuiz() {
    App.startSeries(App.state.currentSeries);
}

function resetAllData() {
    if(confirm("Voulez-vous vraiment effacer tout votre historique ?")) {
        localStorage.removeItem('ccna2_history');
        location.reload();
    }
}

// Bootstrap
document.addEventListener('DOMContentLoaded', () => {
    App.init();
});
