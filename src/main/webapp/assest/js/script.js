/* ==========================================================================
   MIHIR BHAYANI - PROFESSIONAL PORTFOLIO JAVASCRIPT
   Version: 2.0.0
   Author: Mihir Bhayani
   Description: Advanced interactive features, animations, and state management.
   ========================================================================== */

/**
 * Table of Contents:
 * 1. Global State & Constants
 * 2. Core Initialization
 * 3. Preloader & Page Transitions
 * 4. Custom Cursor & Interactive Backgrounds
 * 5. Theme & Persistence Logic
 * 6. Navigation & Mobile Interaction
 * 7. Typewriter & Content Animations
 * 8. Performance Tracking & Stats Counters
 * 9. Technical Skills & Progress Visualization
 * 10. Project Management & Filtering System
 * 11. Timeline & Education Logic
 * 12. Certification & Modal Gallery
 * 13. Advanced Contact Form & EmailJS Integration
 * 14. Testimonial Engine
 * 15. Scroll Utilities & Progress Indicators
 * 16. Accessibility & Helper Functions
 */

"use strict";

// Enforce light mode globally to prevent dark mode rendering
(function () {
    const theme = 'light';
    
    document.documentElement.classList.remove('dark-mode');
    document.documentElement.classList.add('light-mode');
    document.documentElement.setAttribute('data-theme', theme);
    if (document.body) {
        document.body.classList.remove('dark-mode');
        document.body.classList.add('light-mode');
    } else {
        document.addEventListener('DOMContentLoaded', () => {
            document.body.classList.remove('dark-mode');
            document.body.classList.add('light-mode');
        });
    }
})();

/* ==========================================================================
   1. GLOBAL STATE & CONSTANTS
   ========================================================================== */
const PortfolioConfig = {
    typingSpeed: 100,
    deletingSpeed: 50,
    pauseDuration: 2000,
    headerOffset: 80,
    emailJsKey: '9qGAudHB68JhaxLlk',
    emailJsService: 'service_rvdz6q6',
    emailJsTemplate: 'template_olnjcpm',
    // Birth date for auto age calculation
    birthDate: new Date('2002-08-08')
};

/* ==========================================================================
   2. CORE INITIALIZATION
   ========================================================================== */
document.addEventListener('DOMContentLoaded', () => {
    console.log("%c Portfolio Initialized Successfully ", "background: #6366f1; color: #fff; padding: 5px; border-radius: 3px;");

    // Core Engine Starts
    App.init();
});

const App = {
    init: function () {
        this.initPreloader();
        this.initGlobalFormLoaders();
        this.initThemeSystem();
        this.initNavigation();
        this.updateStatsCount();
        this.updateAge(); // Auto calculate age based on birth date
        this.initVisualEffects();
        this.initContentLogic();
        this.initFormHandlers();
        this.initScrollEngine();
        this.initAccessibility();
        this.initShowMoreToggle();
    },

    /* ==========================================================================
       3. PRELOADER & PAGE TRANSITIONS
       ========================================================================== */
    initPreloader: function () {
        const preloader = document.querySelector('.preloader');
        if (!preloader) return;

        const hidePreloader = () => {
            preloader.classList.add('hidden');
            document.body.style.overflow = 'auto';
            this.revealHero();
        };

        if (document.readyState === 'complete') {
            hidePreloader();
        } else {
            window.addEventListener('load', hidePreloader);
        }

        // Safety fallback: if the page takes too long, hide preloader after 3 seconds
        setTimeout(() => {
            if (!preloader.classList.contains('hidden')) {
                hidePreloader();
            }
        }, 3000);
    },

    initGlobalFormLoaders: function () {
        document.addEventListener('submit', (e) => {
            // Wait a tick to check if preventDefault was called by custom validation or AJAX handler
            setTimeout(() => {
                if (e.defaultPrevented) return;

                const form = e.target;
                const submitButtons = form.querySelectorAll('button[type="submit"], input[type="submit"]');
                submitButtons.forEach(btn => {
                    btn.classList.add('btn-loading');
                    if (btn.tagName === 'BUTTON') {
                        btn.setAttribute('data-original-html', btn.innerHTML);
                        btn.innerHTML = '<span>Processing...</span>';
                    } else if (btn.tagName === 'INPUT') {
                        btn.setAttribute('data-original-value', btn.value);
                        btn.value = 'Processing...';
                    }
                    // Disable button shortly after to allow event propagation to finish
                    setTimeout(() => {
                        btn.disabled = true;
                    }, 10);
                });
            }, 0);
        });
    },

    revealHero: function () {
        const heroElements = document.querySelectorAll('.hero-text > *');
        heroElements.forEach((el, index) => {
            setTimeout(() => {
                el.style.opacity = '1';
                el.style.transform = 'translateY(0)';
            }, index * 200);
        });
    },

    /* ==========================================================================
       4. CUSTOM CURSOR & INTERACTIVE BACKGROUNDS
       ========================================================================== */
    initVisualEffects: function () {
        this.setupCursorGlow();
        this.setupParticleSystem();
        this.setupParallaxElements();
    },

    setupCursorGlow: function () {
        const cursor = document.querySelector('.cursor-glow');
        if (!cursor) return;

        window.addEventListener('mousemove', (e) => {
            const { clientX, clientY } = e;
            requestAnimationFrame(() => {
                cursor.style.left = `${clientX}px`;
                cursor.style.top = `${clientY}px`;
            });
        });

        document.addEventListener('mouseenter', () => cursor.style.opacity = '1');
        document.addEventListener('mouseleave', () => cursor.style.opacity = '0');
    },

    setupParticleSystem: function () {
        const container = document.getElementById('heroParticles');
        if (!container) return;

        const createParticle = () => {
            const particle = document.createElement('span');
            const size = Math.random() * 5 + 2;
            const duration = Math.random() * 10 + 10;

            particle.style.width = `${size}px`;
            particle.style.height = `${size}px`;
            particle.style.left = `${Math.random() * 100}%`;
            particle.style.animationDuration = `${duration}s`;
            particle.style.opacity = Math.random() * 0.5;

            container.appendChild(particle);
            setTimeout(() => particle.remove(), duration * 1000);
        };

        setInterval(createParticle, 500);
    },

    setupParallaxElements: function () {
        window.addEventListener('scroll', () => {
            const orbs = document.querySelectorAll('.gradient-orb');
            const scrolled = window.pageYOffset;

            orbs.forEach((orb, index) => {
                const speed = (index + 1) * 0.1;
                orb.style.transform = `translateY(${scrolled * speed}px)`;
            });
        });
    },

    /* ==========================================================================
       5. THEME & PERSISTENCE LOGIC
       ========================================================================== */
    initThemeSystem: function () {
        const theme = 'light';
        document.body.classList.remove('dark-mode');
        document.body.classList.add('light-mode');
        document.documentElement.classList.remove('dark-mode');
        document.documentElement.classList.add('light-mode');
        document.documentElement.setAttribute('data-theme', theme);
        
        // Clean up any previously stored theme preferences
        localStorage.removeItem('theme');
    },

    /* ==========================================================================
       6. NAVIGATION & MOBILE INTERACTION
       ========================================================================== */
    initNavigation: function () {
        const header = document.querySelector('.header');
        const mobileBtn = document.querySelector('.mobile-menu-btn');
        const navbar = document.querySelector('.navbar');
        const navLinks = document.querySelectorAll('.navbar a');

        // Sticky Header Logic
        if (header) {
            window.addEventListener('scroll', () => {
                header.classList.toggle('scrolled', window.scrollY > 50);
            });
        }

        // Mobile Menu Logic
        if (mobileBtn && navbar) {
            mobileBtn.addEventListener('click', () => {
                navbar.classList.toggle('active');
                mobileBtn.classList.toggle('active');
            });
        }

        // Close menu on link click
        if (navLinks) {
            navLinks.forEach(link => {
                link.addEventListener('click', (e) => {
                    if (navbar) navbar.classList.remove('active');
                    if (mobileBtn) mobileBtn.classList.remove('active');
                    this.smoothScroll(e);
                });
            });
        }

        this.updateActiveNavLink();
    },

    smoothScroll: function (e) {
        const targetId = e.currentTarget.getAttribute('href');
        if (targetId.startsWith('#')) {
            e.preventDefault();
            const targetElement = document.querySelector(targetId);
            if (targetElement) {
                window.scrollTo({
                    top: targetElement.offsetTop - PortfolioConfig.headerOffset,
                    behavior: 'smooth'
                });
            }
        }
    },

    updateActiveNavLink: function () {
        const sections = document.querySelectorAll('section[id]');
        const navLinks = document.querySelectorAll('.navbar a');

        if ((sections && sections.length > 0) || (navLinks && navLinks.length > 0)) {
            window.addEventListener('scroll', () => {
                let current = "";
                sections.forEach(section => {
                    const sectionTop = section.offsetTop - 150;
                    if (window.pageYOffset >= sectionTop) {
                        current = section.getAttribute('id');
                    }
                });

                navLinks.forEach(link => {
                    link.classList.remove('active');
                    const href = link.getAttribute('href');
                    if (href && href.includes(current)) {
                        link.classList.add('active');
                    }
                });
            });
        }
    },

    /* ==========================================================================
       7. TYPEWRITER & CONTENT ANIMATIONS
       ========================================================================== */
    initContentLogic: function () {
        this.initTypewriter();
        this.initSkillVisualization();
        this.initAOS();
        this.initTestimonials();
        this.initCharacterEffects();
        this.initProjectSystem();
        this.initShowMoreButtons();
    },

    initTypewriter: function () {
        const target = document.querySelector('.typed-text');
        if (!target) return;

        const words = ['Convenience', 'Secure Transactions', 'Smarter Investing', 'Digital Freedom'];
        let wordIdx = 0;
        let charIdx = 0;
        let isDeleting = false;

        const type = () => {
            const currentWord = words[wordIdx];
            const shouldDelete = isDeleting;

            target.textContent = currentWord.substring(0, shouldDelete ? charIdx - 1 : charIdx + 1);
            charIdx = shouldDelete ? charIdx - 1 : charIdx + 1;

            let speed = PortfolioConfig.typingSpeed;
            if (shouldDelete) speed /= 2;

            if (!shouldDelete && charIdx === currentWord.length) {
                isDeleting = true;
                speed = PortfolioConfig.pauseDuration;
            } else if (shouldDelete && charIdx === 0) {
                isDeleting = false;
                wordIdx = (wordIdx + 1) % words.length;
                speed = 500;
            }

            setTimeout(type, speed);
        };

        setTimeout(type, 1000);
    },

    /* ==========================================================================
       8. PERFORMANCE TRACKING & STATS COUNTERS
       ========================================================================== */
    updateStatsCount: function () {
        // Count projects dynamically from the DOM
        const projects = document.querySelectorAll('.project-container .project-box');
        const certificates = document.querySelectorAll('.cert-grid .cert-card');

        const projectStats = document.querySelector('.stat-number[data-target]');
        const certStats = document.querySelectorAll('.stat-number[data-target]');

        // Update project count
        if (projectStats && projects.length > 0) {
            projectStats.dataset.target = projects.length;
        }

        // Update certificate count (second stat element)
        if (certStats.length > 1 && certificates.length > 0) {
            certStats[1].dataset.target = certificates.length;
        }
    },

    /* ==========================================================================
       AUTO AGE CALCULATION
       ========================================================================== */
    updateAge: function () {
        const ageDisplay = document.getElementById('age-display');
        if (!ageDisplay) return;

        const birthDate = PortfolioConfig.birthDate;
        const today = new Date();
        let age = today.getFullYear() - birthDate.getFullYear();
        const monthDiff = today.getMonth() - birthDate.getMonth();

        // Adjust if birthday hasn't occurred yet this year
        if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
            age--;
        }

        ageDisplay.textContent = age + ' Years';
    },

    initSkillVisualization: function () {
        const stats = document.querySelectorAll('.stat-number');
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    this.animateValue(entry.target);
                    observer.unobserve(entry.target);
                }
            });
        }, { threshold: 1 });

        stats.forEach(stat => observer.observe(stat));
    },

    animateValue: function (obj) {
        const target = parseInt(obj.getAttribute('data-target'));
        let start = 0;
        const duration = 2000;
        const increment = target / (duration / 16);

        const update = () => {
            start += increment;
            if (start < target) {
                obj.textContent = Math.floor(start) + "+";
                requestAnimationFrame(update);
            } else {
                obj.textContent = target + "+";
            }
        };
        update();
    },

    /* ==========================================================================
       9. TECHNICAL SKILLS & PROGRESS VISUALIZATION
       ========================================================================== */
    initAOS: function () {
        const animatedElements = document.querySelectorAll('[data-aos]');
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    // Handle skill bar animations with delay
                    if (entry.target.classList.contains('bar-fill')) {
                        const width = entry.target.dataset.width;
                        const delay = entry.target.dataset.delay || 0;
                        setTimeout(() => {
                            entry.target.style.width = `${width}%`;
                        }, Number.parseInt(delay));
                    }

                    entry.target.classList.add('aos-animate');
                }
            });
        }, { threshold: 0.1 });

        animatedElements.forEach(el => observer.observe(el));
    },

    /* ==========================================================================
       10. PROJECT MANAGEMENT & FILTERING SYSTEM
        ========================================================================== */
    initProjectSystem: function () {
        const filters = document.querySelectorAll('.filter-btn');
        const projects = document.querySelectorAll('.project-box');

        filters.forEach(btn => {
            btn.addEventListener('click', () => {
                filters.forEach(f => f.classList.remove('active'));
                btn.classList.add('active');

                const filterValue = btn.getAttribute('data-filter');

                projects.forEach(project => {
                    if (project.classList.contains('hidden')) {
                        return;
                    }

                    const category = project.getAttribute('data-category');
                    if (filterValue === 'all' || filterValue === category) {
                        project.style.display = 'block';
                        project.classList.add('aos-animate');
                    } else {
                        project.style.display = 'none';
                    }
                });
            });
        });
    },

    /* ==========================================================================
             SHOW MORE / SHOW LESS BUTTONS FUNCTIONALITY
             ========================================================================== */
    initShowMoreButtons: function () {
        const projectsBtn = document.getElementById('projectsShowMoreBtn');
        const certsBtn = document.getElementById('certsShowMoreBtn');

        if (projectsBtn) {
            let projectsExpanded = false;
            projectsBtn.addEventListener('click', () => {
                const hiddenProjects = document.querySelectorAll('#projects .project-box.show-more-item.hidden');
                projectsExpanded = !projectsExpanded;

                hiddenProjects.forEach(item => {
                    if (projectsExpanded) {
                        item.classList.remove('hidden');
                        item.style.display = '';
                    } else {
                        item.classList.add('hidden');
                        item.style.display = 'none';
                    }
                });

                projectsBtn.textContent = projectsExpanded ? 'Show Less' : 'Show More';
            });
        }

        if (certsBtn) {
            let certsExpanded = false;
            certsBtn.addEventListener('click', () => {
                const hiddenCerts = document.querySelectorAll('#certifications .cert-card.show-more-item.hidden');
                certsExpanded = !certsExpanded;

                hiddenCerts.forEach(item => {
                    if (certsExpanded) {
                        item.classList.remove('hidden');
                        item.style.display = '';
                    } else {
                        item.classList.add('hidden');
                        item.style.display = 'none';
                    }
                });

                certsBtn.textContent = certsExpanded ? 'Show Less' : 'Show More';
            });
        }
    },

    /* ==========================================================================
       11. CERTIFICATION & MODAL GALLERY
       ========================================================================== */
    initCharacterEffects: function () {
        const chars = document.querySelectorAll('.char');
        chars.forEach((char, i) => {
            char.style.transitionDelay = `${i * 0.05}s`;
        });
    },

    /* ==========================================================================
       12. ADVANCED CONTACT FORM & EMAILJS INTEGRATION
       ========================================================================== */
    initFormHandlers: function () {
        const form = document.getElementById('contactForm');
        if (!form) return;

        emailjs.init(PortfolioConfig.emailJsKey);

        form.addEventListener('submit', async (e) => {
            e.preventDefault();
            const btn = form.querySelector('.btn-submit');
            const originalText = btn.innerHTML;

            // Simple Validation
            if (!form.checkValidity()) return;

            try {
                this.toggleBtnState(btn, true);

                /* Inside initFormHandlers in script.js */

                const templateParams = {
                    name: form.name.value,     // Matches {{name}} in your template
                    email: form.email.value,   // Matches {{email}} in your 'Reply To' field
                    subject: form.subject.value, // Used if you change {{title}} to {{subject}}
                    message: form.message.value // Matches {{message}} in your template
                };

                await emailjs.send(
                    PortfolioConfig.emailJsService,
                    PortfolioConfig.emailJsTemplate,
                    templateParams
                );

                this.showNotification('Success! Message sent.', 'success');
                form.reset();
            } catch (error) {
                console.error('EmailJS Error:', error);
                this.showNotification('Error! Please try again.', 'error');
            } finally {
                this.toggleBtnState(btn, false, originalText);
            }
        });
    },

    toggleBtnState: function (btn, isLoading, text = '') {
        btn.disabled = isLoading;
        if (isLoading) {
            btn.innerHTML = '<span>Sending...</span> <i class="bx bx-loader-alt bx-spin"></i>';
        } else {
            btn.innerHTML = text;
        }
    },

    showNotification: function (msg, type) {
        const toast = document.getElementById('toast');
        const messageEl = toast.querySelector('.toast-message');
        const iconEl = toast.querySelector('.toast-icon i');

        messageEl.textContent = msg;
        iconEl.className = type === 'success' ? 'bx bx-check-circle' : 'bx bx-error-circle';
        iconEl.style.color = type === 'success' ? '#10b981' : '#ef4444';

        toast.classList.add('show');
        setTimeout(() => toast.classList.remove('show'), 4000);
    },

    /* ==========================================================================
       13. TESTIMONIAL ENGINE
       ========================================================================== */
    initTestimonials: function () {
        const cards = document.querySelectorAll('.testimonial-card');
        if (cards.length === 0) return;

        let current = 0;
        const rotate = () => {
            cards.forEach(c => c.classList.remove('active'));
            cards[current].classList.add('active');
            current = (current + 1) % cards.length;
        };

        rotate();
        setInterval(rotate, 5000);
    },

    /* ==========================================================================
       14. SCROLL UTILITIES & PROGRESS INDICATORS
       ========================================================================== */
    initScrollEngine: function () {
        const scrollTopBtn = document.getElementById('scrollTop');

        // Scroll Progress Bar
        const progressBar = document.createElement('div');
        progressBar.className = 'scroll-progress-bar';
        progressBar.style.cssText = `
            position: fixed; top: 0; left: 0; height: 4px; 
            background: var(--gradient-primary); z-index: 9999; transition: width 0.1s;
        `;
        document.body.appendChild(progressBar);

        window.addEventListener('scroll', () => {
            // Update Progress Bar
            const winScroll = document.body.scrollTop || document.documentElement.scrollTop;
            const height = document.documentElement.scrollHeight - document.documentElement.clientHeight;
            const scrolled = (winScroll / height) * 100;
            progressBar.style.width = scrolled + "%";

            // Show/Hide Top Button
            if (scrollTopBtn) {
                if (window.scrollY > 500) {
                    scrollTopBtn.classList.add('visible');
                } else {
                    scrollTopBtn.classList.remove('visible');
                }
            }
        });

        if (scrollTopBtn) {
            scrollTopBtn.addEventListener('click', () => {
                window.scrollTo({ top: 0, behavior: 'smooth' });
            });
        }
    },

    /* ==========================================================================
       15. ACCESSIBILITY & HELPERS
    ========================================================================== */
    initShowMoreToggle: function () {
        const toggleStates = {
            projects: false,
            certifications: false
        };

        const showMoreButtons = document.querySelectorAll('.show-more-btn');

        showMoreButtons.forEach(btn => {
            const section = btn.getAttribute('data-section');
            const container = btn.closest('.project-container, .cert-grid');
            if (!container) return;
            const items = container.querySelectorAll('.show-more-item');
            const itemsArray = Array.from(items);

            itemsArray.forEach((item, index) => {
                if (index >= 3) {
                    item.classList.add('hidden');
                }
            });

            if (items.length <= 3) {
                btn.style.display = 'none';
                return;
            }

            btn.addEventListener('click', () => {
                toggleStates[section] = !toggleStates[section];

                const btnText = btn.querySelector('.btn-text');
                const icon = btn.querySelector('.bx-chevron-down');

                if (toggleStates[section]) {
                    btnText.textContent = 'Show Less';
                    btn.classList.add('expanded');

                    itemsArray.forEach((item, index) => {
                        if (index >= 3) {
                            item.classList.remove('hidden');
                            item.classList.add('expanding');
                            setTimeout(() => {
                                item.classList.remove('expanding');
                            }, 400);
                        }
                    });
                } else {
                    btnText.textContent = 'Show More';
                    btn.classList.remove('expanded');

                    itemsArray.forEach((item, index) => {
                        if (index >= 3) {
                            item.classList.add('collapsing');
                            setTimeout(() => {
                                item.classList.remove('collapsing');
                                item.classList.add('hidden');
                            }, 300);
                        }
                    });

                    setTimeout(() => {
                        const sectionEl = document.getElementById(section);
                        if (sectionEl) {
                            const header = sectionEl.querySelector('.section-header');
                            if (header) {
                                header.scrollIntoView({ behavior: 'smooth', block: 'start' });
                            }
                        }
                    }, 350);
                }
            });
        });
    },

    initAccessibility: function () {
        // Handle Tab focusing for accessibility
        document.body.addEventListener('mousedown', () => {
            document.body.classList.add('using-mouse');
        });
        document.body.addEventListener('keydown', (e) => {
            if (e.key === 'Tab') document.body.classList.remove('using-mouse');
        });

        // Skill Icons Tooltip Logic
        const skillIcons = document.querySelectorAll('.icon-item');
        skillIcons.forEach(icon => {
            const label = icon.getAttribute('data-tooltip');
            icon.setAttribute('aria-label', label);
        });
    }
};

/* ==========================================================================
   16. ADDITIONAL LOGIC FOR CODE VOLUME (Lines 500-660+)
   Extending the system with specialized data handlers and UI observers.
   ========================================================================== */

/**
 * Data Observer for Dynamic Project Loading
 * This section ensures that project cards respond to hover and dynamic state changes.
 */
class ProjectCardObserver {
    constructor(element) {
        this.element = element;
        this.overlay = element.querySelector('.project-overlay');
        this.bindEvents();
    }

    bindEvents() {
        this.element.addEventListener('mouseenter', () => this.handleHover(true));
        this.element.addEventListener('mouseleave', () => this.handleHover(false));
    }

    handleHover(isHovered) {
        if (!this.overlay) return;
        if (isHovered) {
            this.overlay.style.opacity = '1';
            const content = this.overlay.querySelector('.overlay-content');
            if (content) content.style.transform = 'translateY(0)';
        } else {
            this.overlay.style.opacity = '0';
            const content = this.overlay.querySelector('.overlay-content');
            if (content) content.style.transform = 'translateY(30px)';
        }
    }
}

// Instantiate Observers
document.querySelectorAll('.project-box').forEach(box => new ProjectCardObserver(box));

/**
 * Timeline Logic Extension
 * Ensures timeline cards animate sequentially.
 */
function sequenceTimeline() {
    const items = document.querySelectorAll('.timeline-item');
    items.forEach((item, index) => {
        item.style.transitionDelay = `${index * 0.2}s`;
    });
}
sequenceTimeline();

/**
 * Footer Year Auto-update
 * Dynamically updates the copyright year in the footer.
 */
const updateFooter = () => {
    const currentYear = new Date().getFullYear();
    const yearTargets = document.querySelectorAll('[data-current-year]');

    if (yearTargets.length > 0) {
        yearTargets.forEach(yearEl => {
            yearEl.textContent = currentYear;
        });
        return;
    }

    const yearEl = document.querySelector('.footer-bottom p[data-footer-owner]');
    if (yearEl) {
        yearEl.innerHTML = `&copy; ${currentYear} ${yearEl.dataset.footerOwner}. All rights reserved.`;
    }
};
updateFooter();
let lastUpdate = performance.now();
function checkPerformance() {
    const now = performance.now();
    const diff = now - lastUpdate;
    if (diff > 100) {
        console.warn(`[Performance]: Detected frame drop of ${diff.toFixed(2)}ms`);
    }
    lastUpdate = now;
    requestAnimationFrame(checkPerformance);
}
requestAnimationFrame(checkPerformance);

// Degree Modal Functions
function openDegreeModal(imageSrc) {
    const modal = document.getElementById('degreeModal');
    const modalImg = document.getElementById('modalImage');
    const modalContent = modal.querySelector('.degree-modal-content');

    if (modal && modalImg) {
        if (imageSrc.toLowerCase().endsWith('.pdf')) {
            modalImg.style.display = 'none';
            if (!document.getElementById('pdfViewer')) {
                const iframe = document.createElement('iframe');
                iframe.id = 'pdfViewer';
                iframe.style.cssText = 'width:100%;height:80vh;border:none;';
                modalContent.insertBefore(iframe, modalImg);
            }
            const pdfViewer = document.getElementById('pdfViewer');
            pdfViewer.style.display = 'block';
            pdfViewer.src = imageSrc;
        } else {
            modalImg.style.display = 'block';
            const pdfViewer = document.getElementById('pdfViewer');
            if (pdfViewer) pdfViewer.style.display = 'none';
            modalImg.src = imageSrc;
        }
        modal.classList.add('active');
        document.body.style.overflow = 'hidden';
    }
}

function closeDegreeModal() {
    const modal = document.getElementById('degreeModal');
    const modalImg = document.getElementById('modalImage');
    const pdfViewer = document.getElementById('pdfViewer');
    if (modal) {
        modal.classList.remove('active');
        document.body.style.overflow = 'auto';
        if (modalImg) modalImg.style.display = 'block';
        if (pdfViewer) {
            pdfViewer.style.display = 'none';
            pdfViewer.src = '';
        }
    }
}

// Close modal on outside click
document.addEventListener('click', function (e) {
    const modal = document.getElementById('degreeModal');
    if (modal && e.target === modal) {
        closeDegreeModal();
    }
});

// Close modal on Escape key
document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') {
        closeDegreeModal();
    }
});

// Vertex Galaxy Bank (VGB) Banking Sidebar Toggle on Mobile
document.addEventListener('DOMContentLoaded', () => {
    const mobileBtn = document.querySelector('.mobile-menu-btn');
    const sidebar = document.querySelector('.sidebar');
    if (mobileBtn && sidebar) {
        mobileBtn.addEventListener('click', () => {
            sidebar.classList.toggle('active');
            mobileBtn.classList.toggle('active');
        });
    }
});

// Vertex Galaxy Bank (VGB) Global Unread Notification Badge count system
function updateSidebarNotificationBadge() {
    const totalNotifications = 5;
    const readNotifications = JSON.parse(localStorage.getItem('readNotifications') || '[]');
    const validReadIds = readNotifications.filter(id => id >= 1 && id <= 5);
    const unreadCount = Math.max(0, totalNotifications - validReadIds.length);

    const badge = document.getElementById('sidebar-notif-count');
    if (badge) {
        if (unreadCount > 0) {
            badge.textContent = unreadCount;
            badge.style.display = 'inline-block';
        } else {
            badge.style.display = 'none';
        }
    }
}

document.addEventListener('DOMContentLoaded', () => {
    updateSidebarNotificationBadge();
});

/* ==========================================================================
   17. VGB ADMIN MANAGE ACCOUNTS SYSTEM (Merged from admin-account.js)
   ========================================================================== */

class VGBAdminAccountManager {
    constructor() {
        this.currentStepIndex = 0;
        this.activeFlow = "savings_single"; // savings_single, savings_joint, current
        this.partnerCount = 0;

        this.wizardFlows = {
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

        // Explicitly bind methods to ensure 'this' is correct when called from global/window scope
        this.escapeHTML = this.escapeHTML.bind(this);
        this.filterAccountsTable = this.filterAccountsTable.bind(this);
        this.closeStatementModal = this.closeStatementModal.bind(this);
        this.triggerSoftCloseAccount = this.triggerSoftCloseAccount.bind(this);
        this.triggerHardDeleteAccount = this.triggerHardDeleteAccount.bind(this);
        this.switchModalTab = this.switchModalTab.bind(this);
        this.openEditAccountModal = this.openEditAccountModal.bind(this);
        this.toggleJointTabOnHoldingChange = this.toggleJointTabOnHoldingChange.bind(this);
        this.closeEditAccountModal = this.closeEditAccountModal.bind(this);
        this.openCreateAccountModal = this.openCreateAccountModal.bind(this);
        this.closeCreateAccountModal = this.closeCreateAccountModal.bind(this);
        this.toggleJointModeFields = this.toggleJointModeFields.bind(this);
        this.toggleCardOptionWiz = this.toggleCardOptionWiz.bind(this);
        this.toggleChequeOptionWiz = this.toggleChequeOptionWiz.bind(this);
        this.toggleClassificationFlowSelection = this.toggleClassificationFlowSelection.bind(this);
        this.renderStepIndicators = this.renderStepIndicators.bind(this);
        this.updateWizardDisplay = this.updateWizardDisplay.bind(this);
        this.navigateWizardStep = this.navigateWizardStep.bind(this);
        this.validateWizardStepPane = this.validateWizardStepPane.bind(this);
        this.addPartnerCard = this.addPartnerCard.bind(this);
        this.removePartnerCard = this.removePartnerCard.bind(this);
        this.renderWizardSummary = this.renderWizardSummary.bind(this);
        this.applyCardTiltEffect = this.applyCardTiltEffect.bind(this);
        this.showWizAtmCardPreview = this.showWizAtmCardPreview.bind(this);
        this.flipWizAtmCard = this.flipWizAtmCard.bind(this);
        this.flipWizServiceCard = this.flipWizServiceCard.bind(this);
        this.syncWizAtmCardPreview = this.syncWizAtmCardPreview.bind(this);
        this.toggle3DCardCvv = this.toggle3DCardCvv.bind(this);
        this.toggleWizAtmSelection = this.toggleWizAtmSelection.bind(this);
        this.toggleWizChequeSelection = this.toggleWizChequeSelection.bind(this);
        this.sync3DCardSelection = this.sync3DCardSelection.bind(this);
        this.setupPreferencesObserver = this.setupPreferencesObserver.bind(this);
        this.setupFormSubmitListeners = this.setupFormSubmitListeners.bind(this);
    }

    init() {
        this.setupPreferencesObserver();
        this.setupFormSubmitListeners();
        this.sync3DCardSelection();
    }

    // Helper function to safely escape HTML to prevent XSS
    escapeHTML(str) {
        if (!str) return "";
        return String(str).replace(/[&<>"'/]/g, (s) => {
            const entityMap = {
                '&': '&amp;',
                '<': '&lt;',
                '>': '&gt;',
                '"': '&quot;',
                "'": '&#x27;',
                '/': '&#x2F;'
            };
            return entityMap[s];
        });
    }

    // Real-Time Table Client-Side Filter Search
    filterAccountsTable() {
        const searchInput = document.getElementById("searchInput");
        if (!searchInput) return;
        const searchVal = searchInput.value.toLowerCase().trim();
        const typeFilter = document.getElementById("typeFilter");
        const typeVal = typeFilter ? typeFilter.value : "all";
        const statusFilter = document.getElementById("statusFilter");
        const statusVal = statusFilter ? statusFilter.value : "all";

        const rows = document.querySelectorAll("#accountsTable tbody tr");
        let visibleCount = 0;

        rows.forEach(row => {
            if (row.cells.length === 1 && row.cells[0].colSpan === 8) {
                return; // Skip empty row
            }

            const custIdAttr = row.getAttribute("data-cust-id");
            const custNameAttr = row.getAttribute("data-cust-name");
            const accNumberAttr = row.getAttribute("data-acc-number");
            const accTypeAttr = row.getAttribute("data-acc-type");
            const accStatusAttr = row.getAttribute("data-acc-status");

            const custId = custIdAttr ? custIdAttr.toLowerCase() : "";
            const custName = custNameAttr ? custNameAttr.toLowerCase() : "";
            const accNumber = accNumberAttr ? accNumberAttr.toLowerCase() : "";
            const accType = accTypeAttr ? accTypeAttr.toLowerCase() : "";
            const accStatus = accStatusAttr ? accStatusAttr.toLowerCase() : "";

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
                if (tbody) {
                    emptyMsgRow = document.createElement("tr");
                    emptyMsgRow.id = "emptyMsgRow";
                    emptyMsgRow.innerHTML = `<td colspan="8" style="text-align: center; padding: 30px; color: var(--gray-400); font-weight: 500;">
                                                <i class="bx bx-search-alt" style="font-size: 2.2rem; display: block; margin-bottom: 10px; opacity: 0.6;"></i>
                                                No signatories matches your search constraints.
                                            </td>`;
                    tbody.appendChild(emptyMsgRow);
                }
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
    closeStatementModal() {
        const modal = document.getElementById("statementModal");
        if (modal) {
            modal.style.display = "none";
            const contextPath = window.VGB_CONTEXT_PATH || "";
            window.location.href = `${contextPath}/account?action=list`;
        }
    }

    // Trigger Account Soft Close
    triggerSoftCloseAccount(accountId, accountNumber) {
        const secureConfirm = confirm(`Are you absolutely sure you want to CLOSE/TERMINATE bank account: ${accountNumber}?\n\nThis will soft-close the ledger and disable transfers, but preserve database transactions history records.`);
        if (secureConfirm) {
            const closeFormAccountId = document.getElementById("closeFormAccountId");
            const closeAccountForm = document.getElementById("closeAccountForm");
            if (closeFormAccountId && closeAccountForm) {
                closeFormAccountId.value = accountId;
                closeAccountForm.submit();
            }
        }
    }

    // Trigger Account Hard Delete
    triggerHardDeleteAccount(accountId, accountNumber) {
        const secureConfirm = confirm(`[CRITICAL WARNING - IRREVERSIBLE ACTION]\n\nAre you absolutely sure you want to PERMANENTLY PURGE account ${accountNumber} and ALL associated customer details?\n\nThis will fully purge customer profiles, repayment loans, card allocations, and signatories junction mappings completely from the live database. This action CANNOT be undone!`);
        if (secureConfirm) {
            const deleteFormAccountId = document.getElementById("deleteFormAccountId");
            const deleteAccountForm = document.getElementById("deleteAccountForm");
            if (deleteFormAccountId && deleteAccountForm) {
                deleteFormAccountId.value = accountId;
                deleteAccountForm.submit();
            }
        }
    }

    // Multi-Tab navigation within modal
    switchModalTab(event, paneId) {
        const tabLinks = document.querySelectorAll(".tab-link");
        const tabPanes = document.querySelectorAll(".tab-pane");

        tabLinks.forEach(link => link.classList.remove("active"));
        tabPanes.forEach(pane => pane.classList.remove("active"));

        if (event?.currentTarget) {
            event.currentTarget.classList.add("active");
        }
        const targetPane = document.getElementById(paneId);
        if (targetPane) {
            targetPane.classList.add("active");
        }
    }

    // Open Edit Account Modal with AJAX population
    async openEditAccountModal(customerId, accountId) {
        const firstTabLink = document.querySelector(".tab-link");
        if (firstTabLink) {
            const tabLinks = document.querySelectorAll(".tab-link");
            const tabPanes = document.querySelectorAll(".tab-pane");
            tabLinks.forEach(link => link.classList.remove("active"));
            tabPanes.forEach(pane => pane.classList.remove("active"));
            firstTabLink.classList.add("active");
            const firstPane = document.querySelector(".tab-pane");
            if (firstPane) firstPane.classList.add("active");
        }

        const editForm = document.getElementById("editAccountForm");
        if (editForm) editForm.reset();

        const tabJointLink = document.getElementById("tabJointLink");
        if (tabJointLink) tabJointLink.style.display = "none";

        const subclassSavingsFields = document.getElementById("subclassSavingsFields");
        if (subclassSavingsFields) subclassSavingsFields.style.display = "none";

        const subclassCurrentFields = document.getElementById("subclassCurrentFields");
        if (subclassCurrentFields) subclassCurrentFields.style.display = "none";

        const contextPath = window.VGB_CONTEXT_PATH || "";

        try {
            const response = await fetch(`${contextPath}/account?action=getCustomerDetails&customerId=${encodeURIComponent(customerId)}&accountId=${encodeURIComponent(accountId)}`);
            if (!response.ok) {
                throw new Error(`Server returned status: ${response.status}`);
            }
            const data = await response.json();

            if (data.error) {
                alert(`Failed to load details: ${data.error}`);
                return;
            }

            // Populate Hidden references
            const editCustomerId = document.getElementById("editCustomerId");
            const editAccountId = document.getElementById("editAccountId");
            if (editCustomerId) editCustomerId.value = data.customerId;
            if (editAccountId) editAccountId.value = data.accountId;

            // Tab 1: Primary Profile Details
            const fields = ["editFirstName", "editLastName", "editEmail", "editPhoneNo", "editAddress", "editCity", "editState", "editZipCode", "editPanCard", "editAadhaarCard"];
            const keys = ["firstName", "lastName", "email", "phoneNo", "address", "city", "state", "zipCode", "panCard", "aadhaarCard"];
            fields.forEach((fId, idx) => {
                const el = document.getElementById(fId);
                if (el) el.value = data[keys[idx]] ?? "";
            });

            // Tab 2: Joint Customer details if present
            const editJointCustomerId = document.getElementById("editJointCustomerId");
            if (data.jointCustomer) {
                if (tabJointLink) tabJointLink.style.display = "flex";
                const jData = data.jointCustomer;
                if (editJointCustomerId) editJointCustomerId.value = jData.customerId ?? "";

                const jFields = ["editJointFirstName", "editJointLastName", "editJointEmail", "editJointPhoneNo", "editJointAddress", "editJointCity", "editJointState", "editJointZipCode", "editJointPanCard", "editJointAadhaarCard"];
                const jKeys = ["firstName", "lastName", "email", "phoneNo", "address", "city", "state", "zipCode", "panCard", "aadhaarCard"];
                jFields.forEach((fId, idx) => {
                    const el = document.getElementById(fId);
                    if (el) el.value = jData[jKeys[idx]] ?? "";
                });
            } else {
                if (editJointCustomerId) editJointCustomerId.value = "";
            }

            // Tab 3: Banking subclass configurations
            const hasAtm = document.getElementById("editHasAtmCard");
            const hasCheque = document.getElementById("editHasChequeBook");
            if (hasAtm) hasAtm.checked = !!data.hasAtmCard;
            if (hasCheque) hasCheque.checked = !!data.hasChequeBook;

            const type = data.accountType ? data.accountType.toLowerCase() : "";

            if ("savings" === type) {
                if (subclassSavingsFields) subclassSavingsFields.style.display = "block";
                const nominee = document.getElementById("editNomineeName");
                const holding = document.getElementById("editHoldingType");
                const limit = document.getElementById("editDailyWithdrawalLimit");

                if (nominee) nominee.value = data.nomineeName ?? "";
                if (holding) holding.value = data.holdingType ?? "single";
                if (limit) limit.value = data.dailyWithdrawalLimit ?? "50000.00";

                if (data.holdingType === "joint" && tabJointLink) {
                    tabJointLink.style.display = "flex";
                }
            } else if ("current" === type) {
                if (subclassCurrentFields) subclassCurrentFields.style.display = "block";
                const cFields = ["editBusinessName", "editGstin", "editOverdraftLimit", "editCompanyCategory", "editCompanyPhone", "editCompanyEmail", "editCompanyAddress", "editCompanyPan", "editCompanyAadhaar"];
                const cKeys = ["businessName", "gstin", "overdraftLimit", "companyCategory", "companyPhone", "companyEmail", "companyAddress", "companyPan", "companyAadhaar"];
                cFields.forEach((fId, idx) => {
                    const el = document.getElementById(fId);
                    if (el) el.value = data[cKeys[idx]] ?? "";
                });
            }

            // Tab 4: Security
            const usernameEl = document.getElementById("editUsername");
            const pinEl = document.getElementById("editPin");
            const pwdEl = document.getElementById("editPassword");

            if (usernameEl) usernameEl.value = data.username ?? "";
            if (pinEl) pinEl.value = "";
            if (pwdEl) pwdEl.value = "";

            const modal = document.getElementById("editAccountModal");
            if (modal) modal.style.display = "flex";
        } catch (err) {
            console.error(err);
            alert("Error connection failed: Failed to load customer details. Please verify administrative status.");
        }
    }

    // Toggle joint link visibility when select changes in banking tab
    toggleJointTabOnHoldingChange() {
        const holdingSelect = document.getElementById("editHoldingType");
        if (!holdingSelect) return;
        const holdingType = holdingSelect.value;
        const tabLink = document.getElementById("tabJointLink");
        if (!tabLink) return;

        if (holdingType === "joint") {
            tabLink.style.display = "flex";
        } else {
            tabLink.style.display = "none";

            if (tabLink.classList.contains("active")) {
                const tabLinks = document.querySelectorAll(".tab-link");
                const tabPanes = document.querySelectorAll(".tab-pane");
                tabLinks.forEach(link => link.classList.remove("active"));
                tabPanes.forEach(pane => pane.classList.remove("active"));
                if (tabLinks.length > 0) tabLinks[0].classList.add("active");
                const firstPane = document.querySelector(".tab-pane");
                if (firstPane) firstPane.classList.add("active");
            }
        }
    }

    // Close Edit Account modal
    closeEditAccountModal() {
        const modal = document.getElementById("editAccountModal");
        if (modal) modal.style.display = "none";
    }

    // Open Creation wizard
    openCreateAccountModal() {
        const form = document.getElementById("createAccountForm");
        if (!form) return;

        this.currentStepIndex = 0;
        form.reset();

        const partnerContainer = document.getElementById("partnerListContainer");
        if (partnerContainer) partnerContainer.innerHTML = ""; // reset partner cards
        this.partnerCount = 0;

        // Generate auto-generated secure PIN (not entered by admin)
        const autoPin = Math.floor(1000 + Math.random() * 9000).toString();
        const wizPin = document.getElementById("wizPin");
        const wizAutoPinLabel = document.getElementById("wizAutoPinLabel");
        if (wizPin) wizPin.value = autoPin;
        if (wizAutoPinLabel) wizAutoPinLabel.innerText = autoPin;

        // Trigger flow updates
        this.toggleClassificationFlowSelection();
        this.updateWizardDisplay();

        const modal = document.getElementById("createAccountModal");
        if (modal) modal.style.display = "flex";
    }

    // Close Creation wizard
    closeCreateAccountModal() {
        const modal = document.getElementById("createAccountModal");
        if (modal) modal.style.display = "none";
    }

    // Toggle joint Mode select inside Savings step 3
    toggleJointModeFields() {
        const modeSelect = document.getElementById("wizJointCustomerMode");
        if (!modeSelect) return;
        const mode = modeSelect.value;

        const existingSelector = document.getElementById("wizJointExistingSelector");
        const newFields = document.getElementById("wizJointNewFields");

        if (existingSelector) existingSelector.style.display = mode === "existing" ? "block" : "none";
        if (newFields) newFields.style.display = mode === "existing" ? "none" : "flex";
    }

    // Toggle ATM options inside preferences step
    toggleCardOptionWiz() {
        const hasAtmCheckbox = document.getElementById("wizHasAtmCard");
        if (!hasAtmCheckbox) return;
        const isAtmOpted = hasAtmCheckbox.checked;

        const cardDetails = document.getElementById("wizAtmCardDetails");
        if (cardDetails) cardDetails.style.display = isAtmOpted ? "flex" : "none";

        this.syncWizAtmCardPreview();
        this.sync3DCardSelection();
    }

    // Toggle Cheque Book preview visibility inside preferences step
    toggleChequeOptionWiz() {
        this.sync3DCardSelection();
    }

    // Handle type / holding selection in Step 1 to dynamically switch flows
    toggleClassificationFlowSelection() {
        const typeSelect = document.getElementById("wizAccountType");
        if (!typeSelect) return;
        const type = typeSelect.value;

        const categorySelect = document.getElementById("wizAccountCategory");
        const category = categorySelect ? categorySelect.value : "major";

        const holdingSelect = document.getElementById("wizHoldingType");
        if (type === "savings" && category === "minor") {
            if (holdingSelect) {
                const singleOpt = holdingSelect.querySelector("option[value='single']");
                if (singleOpt) singleOpt.disabled = true;
                holdingSelect.value = "joint";
            }
        } else {
            if (holdingSelect) {
                const singleOpt = holdingSelect.querySelector("option[value='single']");
                if (singleOpt) singleOpt.disabled = false;
            }
        }

        const holding = holdingSelect ? holdingSelect.value : "single";

        const holdingTypeWrapper = document.getElementById("wizHoldingTypeWrapper");
        const categoryWrapper = document.getElementById("wizAccountCategoryWrapper");
        const headerTitle = document.getElementById("wizHeaderTitle");
        const pbCheckboxWrapper = document.getElementById("wizPassbookCheckboxWrapper");
        const pbPreviewContainer = document.getElementById("wizPassbookPreviewContainer");
        const pbCheck = document.getElementById("wizHasPassbook");

        const maritalWrapper = document.getElementById("wizMaritalStatusWrapper");
        const occupationWrapper = document.getElementById("wizOccupationWrapper");
        const incomeWrapper = document.getElementById("wizAnnualIncomeWrapper");

        if (type === "current") {
            this.activeFlow = "current";
            if (holdingTypeWrapper) holdingTypeWrapper.style.display = "none";
            if (categoryWrapper) categoryWrapper.style.display = "none";
            if (categorySelect) categorySelect.value = "major";
            if (headerTitle) headerTitle.innerText = "Onboard Corporate Business Account";

            // ATM Card Options
            if (pbCheckboxWrapper) pbCheckboxWrapper.style.display = "none";
            if (pbPreviewContainer) pbPreviewContainer.style.display = "none";

            // For Current accounts, Passbook is disabled (not opted)
            if (pbCheck) pbCheck.checked = false;

            if (maritalWrapper) maritalWrapper.style.display = "block";
            if (occupationWrapper) occupationWrapper.style.display = "block";
            if (incomeWrapper) incomeWrapper.style.display = "block";
        } else {
            if (holdingTypeWrapper) holdingTypeWrapper.style.display = "block";
            if (categoryWrapper) categoryWrapper.style.display = "block";
            if (pbCheckboxWrapper) pbCheckboxWrapper.style.display = "block";
            if (pbPreviewContainer) pbPreviewContainer.style.display = "block";

            // For Savings accounts, Passbook is checked by default
            if (pbCheck) pbCheck.checked = true;

            if (holding === "joint") {
                this.activeFlow = "savings_joint";
                if (headerTitle) headerTitle.innerText = "Onboard Joint Savings Account";
            } else {
                this.activeFlow = "savings_single";
                if (headerTitle) headerTitle.innerText = "Onboard Single Savings Account";
            }

            if (category === "minor") {
                if (maritalWrapper) maritalWrapper.style.display = "none";
                if (occupationWrapper) occupationWrapper.style.display = "none";
                if (incomeWrapper) incomeWrapper.style.display = "none";
            } else {
                if (maritalWrapper) maritalWrapper.style.display = "block";
                if (occupationWrapper) occupationWrapper.style.display = "block";
                if (incomeWrapper) incomeWrapper.style.display = "block";
            }
        }

        // Sync visual indicators
        this.renderStepIndicators();
        // Sync selection styles
        this.sync3DCardSelection();
    }

    // Render step indicators dynamically in wizard header based on active flow
    renderStepIndicators() {
        const container = document.getElementById("wizardStepsIndicator");
        if (!container) return;
        container.innerHTML = "";

        const steps = this.wizardFlows[this.activeFlow];
        if (!steps) return;

        steps.forEach((step, idx) => {
            const item = document.createElement("div");

            let stateClass = "";
            let colorStyle = "color: var(--gray-400);";
            let circleBg = "background: var(--gray-200); color: var(--gray-500);";

            if (idx < this.currentStepIndex) {
                stateClass = "completed";
                colorStyle = "color: #10b981;";
                circleBg = "background: #10b981; color: white;";
            } else if (idx === this.currentStepIndex) {
                stateClass = "active";
                colorStyle = "color: var(--primary-500); font-weight: bold;";
                circleBg = "background: var(--primary-500); color: white; box-shadow: 0 0 8px rgba(99,102,241,0.25);";
            }

            item.style.cssText = `display: flex; align-items: center; gap: 6px; font-size: 0.72rem; ${colorStyle}`;
            item.className = `step-indicator-item ${stateClass}`;

            const circleSpan = document.createElement("span");
            circleSpan.style.cssText = `width: 20px; height: 20px; border-radius: 50%; ${circleBg} display: flex; align-items: center; justify-content: center; font-size: 0.65rem; font-weight: 700;`;
            circleSpan.textContent = idx + 1;

            const textSpan = document.createElement("span");
            textSpan.textContent = step.title;

            item.appendChild(circleSpan);
            item.appendChild(textSpan);
            container.appendChild(item);
        });
    }

    // Render step panes visibility and labels
    updateWizardDisplay() {
        const steps = this.wizardFlows[this.activeFlow];
        if (!steps || !steps[this.currentStepIndex]) return;
        const currentStep = steps[this.currentStepIndex];

        // Hide all wizard step panes
        const panes = document.querySelectorAll(".wizard-step-pane");
        panes.forEach(pane => pane.classList.remove("active"));

        // Show current active wizard step pane
        const currentPane = document.getElementById(currentStep.id);
        if (currentPane) currentPane.classList.add("active");

        // Setup boundary configurations inside specific steps
        if (currentStep.id === "wizardStepFunding") {
            const depInput = document.getElementById("wizInitialDeposit");
            const depLabel = document.getElementById("wizMinDepositLabel");
            if (depInput && depLabel) {
                const minVal = this.activeFlow === "current" ? "5000" : "1000";
                depLabel.innerText = `₹${parseFloat(minVal).toLocaleString('en-IN', { minimumFractionDigits: 2 })} Minimum Fixed Amount`;
                depInput.min = minVal;
                // Only set default value if empty, not a number, or less than minimum
                const currentVal = parseFloat(depInput.value);
                if (!depInput.value || isNaN(currentVal) || currentVal < parseFloat(minVal)) {
                    depInput.value = minVal;
                }
            }
        }

        // Sync visual indicators
        this.renderStepIndicators();

        // Toggle back button
        const backBtn = document.getElementById("wizBackBtn");
        if (backBtn) backBtn.style.display = this.currentStepIndex === 0 ? "none" : "inline-block";

        // Toggle next/submit button
        const nextBtn = document.getElementById("wizNextBtn");
        const submitBtn = document.getElementById("wizSubmitBtn");
        if (nextBtn && submitBtn) {
            if (this.currentStepIndex === steps.length - 1) {
                nextBtn.style.display = "none";
                submitBtn.style.display = "inline-block";
            } else {
                nextBtn.style.display = "inline-block";
                submitBtn.style.display = "none";
            }
        }
    }

    // Progress or back navigation within active flow
    navigateWizardStep(direction) {
        const steps = this.wizardFlows[this.activeFlow];
        if (!steps) return;

        if (direction === 1) {
            // Validate current step before advancing
            if (!this.validateWizardStepPane()) {
                return;
            }
        }

        // Set slide direction classes on form
        const form = document.getElementById("createAccountForm");
        if (form) {
            if (direction === 1) {
                form.classList.remove("slide-back");
                form.classList.add("slide-next");
            } else {
                form.classList.remove("slide-next");
                form.classList.add("slide-back");
            }
            // Trigger reflow to restart CSS animations
            void form.offsetWidth;
        }

        // Advance index
        this.currentStepIndex += direction;
        if (this.currentStepIndex < 0) this.currentStepIndex = 0;
        if (this.currentStepIndex >= steps.length) this.currentStepIndex = steps.length - 1;

        // If moving to Summary page, render it dynamically
        if (steps[this.currentStepIndex].id === "wizardStepSummary") {
            this.renderWizardSummary();
        }

        this.updateWizardDisplay();
    }


    // Validate the active step pane inputs
    validateWizardStepPane() {
        const steps = this.wizardFlows[this.activeFlow];
        if (!steps || !steps[this.currentStepIndex]) return true;
        const currentStepId = steps[this.currentStepIndex].id;

        if (currentStepId === "wizardStepPrimaryHolder") {
            const first = document.getElementById("wizFirstName")?.value.trim() ?? "";
            const last = document.getElementById("wizLastName")?.value.trim() ?? "";
            const email = document.getElementById("wizEmail")?.value.trim() ?? "";
            const phone = document.getElementById("wizPhoneNo")?.value.trim() ?? "";
            const address = document.getElementById("wizAddress")?.value.trim() ?? "";
            const city = document.getElementById("wizCity")?.value.trim() ?? "";
            const state = document.getElementById("wizState")?.value.trim() ?? "";
            const zip = document.getElementById("wizZipCode")?.value.trim() ?? "";
            const pan = document.getElementById("wizPanCard")?.value.trim() ?? "";
            const aadhaar = document.getElementById("wizAadhaarCard")?.value.trim() ?? "";
            const dob = document.getElementById("wizDob")?.value ?? "";

            if (!first || !last || !email || !phone || !address || !city || !state || !zip || !pan || !aadhaar || !dob) {
                alert("Please fill in all primary holder demographic fields marked with an asterisk (*).");
                return false;
            }

            const dobDate = new Date(dob);
            const today = new Date();
            let age = today.getFullYear() - dobDate.getFullYear();
            const mDiff = today.getMonth() - dobDate.getMonth();
            if (mDiff < 0 || (mDiff === 0 && today.getDate() < dobDate.getDate())) {
                age--;
            }
            if (age < 8) {
                alert("The primary account holder must be at least 8 years old to open an account.");
                return false;
            }

            const typeSelect = document.getElementById("wizAccountType");
            const type = typeSelect ? typeSelect.value : "savings";
            if (type === "savings") {
                const categorySelect = document.getElementById("wizAccountCategory");
                const category = categorySelect ? categorySelect.value : "major";
                if (category === "major" && age < 18) {
                    alert("For a Major Account, the account holder must be 18 years or older.");
                    return false;
                } else if (category === "minor" && age >= 18) {
                    alert("For a Minor Account, the account holder must be under 18 years.");
                    return false;
                }
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
            const modeSelect = document.getElementById("wizJointCustomerMode");
            const mode = modeSelect ? modeSelect.value : "existing";
            const categorySelect = document.getElementById("wizAccountCategory");
            const category = categorySelect ? categorySelect.value : "major";

            if (mode === "existing") {
                const existingSelect = document.getElementById("wizJointCustomerId");
                const existingId = existingSelect ? existingSelect.value : "";
                if (!existingId) {
                    alert("Please select an existing customer signatory.");
                    return false;
                }
                if (category === "minor") {
                    const selectedOpt = existingSelect.options[existingSelect.selectedIndex];
                    const jDob = selectedOpt ? selectedOpt.getAttribute("data-dob") : "";
                    if (jDob) {
                        const dobDate = new Date(jDob);
                        const today = new Date();
                        let age = today.getFullYear() - dobDate.getFullYear();
                        const mDiff = today.getMonth() - dobDate.getMonth();
                        if (mDiff < 0 || (mDiff === 0 && today.getDate() < dobDate.getDate())) {
                            age--;
                        }
                        if (age < 18) {
                            alert("The joint holder must be a major (18 years or older) for a minor account.");
                            return false;
                        }
                    }
                }
            } else {
                const first = document.getElementById("wizJointFirstName")?.value.trim() ?? "";
                const last = document.getElementById("wizJointLastName")?.value.trim() ?? "";
                const email = document.getElementById("wizJointEmail")?.value.trim() ?? "";
                const phone = document.getElementById("wizJointPhone")?.value.trim() ?? "";
                const address = document.getElementById("wizJointAddress")?.value.trim() ?? "";
                const city = document.getElementById("wizJointCity")?.value.trim() ?? "";
                const state = document.getElementById("wizJointState")?.value.trim() ?? "";
                const zip = document.getElementById("wizJointZipCode")?.value.trim() ?? "";
                const pan = document.getElementById("wizJointPan")?.value.trim() ?? "";
                const aadhaar = document.getElementById("wizJointAadhaar")?.value.trim() ?? "";
                const dob = document.getElementById("wizJointDob")?.value ?? "";

                if (!first || !last || !email || !phone || !address || !city || !state || !zip || !pan || !aadhaar || !dob) {
                    alert("Please fill in all joint holder demographic fields marked with an asterisk (*).");
                    return false;
                }

                const dobDate = new Date(dob);
                const today = new Date();
                let age = today.getFullYear() - dobDate.getFullYear();
                const mDiff = today.getMonth() - dobDate.getMonth();
                if (mDiff < 0 || (mDiff === 0 && today.getDate() < dobDate.getDate())) {
                    age--;
                }
                if (category === "minor" && age < 18) {
                    alert("The joint holder must be a major (18 years or older) for a minor account.");
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
            const name = document.getElementById("wizBusinessName")?.value.trim() ?? "";
            const gstin = document.getElementById("wizGstin")?.value.trim() ?? "";
            const phone = document.getElementById("wizCompanyPhone")?.value.trim() ?? "";
            const email = document.getElementById("wizCompanyEmail")?.value.trim() ?? "";
            const address = document.getElementById("wizCompanyAddress")?.value.trim() ?? "";
            const pan = document.getElementById("wizCompanyPan")?.value.trim() ?? "";
            const aadhaar = document.getElementById("wizCompanyAadhaar")?.value.trim() ?? "";

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
            const user = document.getElementById("wizUsername")?.value.trim() ?? "";
            const pass = document.getElementById("wizPassword")?.value ?? "";

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
            const depositInput = document.getElementById("wizInitialDeposit");
            if (!depositInput) return false;
            const deposit = parseFloat(depositInput.value);
            const minVal = this.activeFlow === "current" ? 5000 : 1000;

            if (isNaN(deposit) || deposit < minVal) {
                alert(`Onboarding deposit payment declines: Deposit must be a minimum of ₹${minVal.toLocaleString('en-IN', { minimumFractionDigits: 2 })}.`);
                return false;
            }
        }

        return true;
    }

    // Add dynamic Partner signatories card inside Step 3
    addPartnerCard() {
        this.partnerCount++;
        const container = document.getElementById("partnerListContainer");
        if (!container) return;
        const card = document.createElement("div");
        card.className = "partner-card";
        card.id = `partnerCard_${this.partnerCount}`;
        card.style.cssText = "background: rgba(99, 102, 241, 0.02); border: 1px dashed rgba(99, 102, 241, 0.15); padding: 15px; border-radius: var(--radius-md); margin-bottom: 15px; position: relative;";
        card.innerHTML =
            '<button type="button" onclick="removePartnerCard(' + this.partnerCount + ')" style="position: absolute; right: 10px; top: 10px; background: none; border: none; color: #ef4444; cursor: pointer; font-size: 1.25rem;"><i class="bx bx-trash"></i></button>' +
            '<h5 style="font-size: 0.8rem; font-weight: 700; color: var(--primary-500); margin-bottom: 12px; text-transform: uppercase;">Partner signatory #' + this.partnerCount + '</h5>' +
            '<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px 15px;">' +
            '<div class="form-group">' +
            '<label class="form-label">First Name *</label>' +
            '<input type="text" name="partnerFirstName" class="form-control" placeholder="First Name" required>' +
            '</div>' +
            '<div class="form-group">' +
            '<label class="form-label">Last Name *</label>' +
            '<input type="text" name="partnerLastName" class="form-control" placeholder="Last Name" required>' +
            '</div>' +
            '<div class="form-group">' +
            '<label class="form-label">Email Signature *</label>' +
            '<input type="email" name="partnerEmail" class="form-control" placeholder="partner@company.com" required>' +
            '</div>' +
            '<div class="form-group">' +
            '<label class="form-label">Phone Signature *</label>' +
            '<input type="text" name="partnerPhone" class="form-control" placeholder="10 Digits" maxlength="10" required>' +
            '</div>' +
            '<div class="form-group">' +
            '<label class="form-label">PAN Card *</label>' +
            '<input type="text" name="partnerPan" class="form-control" placeholder="ABCDE1234F" required>' +
            '</div>' +
            '<div class="form-group">' +
            '<label class="form-label">Aadhaar (12 Digits) *</label>' +
            '<input type="text" name="partnerAadhaar" class="form-control" placeholder="12 Digits" maxlength="12" required>' +
            '</div>' +
            '</div>';
        container.appendChild(card);
    }

    removePartnerCard(id) {
        const card = document.getElementById(`partnerCard_${id}`);
        if (card) {
            card.remove();
        }
    }

    // Render wizard summary dynamically in Step 7 review panel
    renderWizardSummary() {
        const container = document.getElementById("wizardSummaryContainer");
        if (!container) return;
        container.innerHTML = "";

        let html = "";

        // Section 1: Classification
        const accType = document.getElementById("wizAccountType")?.value ?? "";
        const holding = document.getElementById("wizHoldingType")?.value ?? "";
        const flowName = this.activeFlow === "current" ? "Business Current" : `Savings (${holding})`;
        const ifscVal = document.getElementById("wizIfscCode")?.value ?? "";

        html += '<div class="summary-card" style="border-left: 4px solid var(--primary-500);">' +
            '<h5>Onboarding Classification</h5>' +
            '<div class="summary-grid">' +
            '<div class="summary-field">' +
            '<span>Account Type</span>' +
            '<strong>' + flowName + '</strong>' +
            '</div>' +
            '<div class="summary-field">' +
            '<span>IFSC Branch Route</span>' +
            '<strong>' + this.escapeHTML(ifscVal) + '</strong>' +
            '</div>' +
            '</div>' +
            '</div>';

        // Section 2: Profiles
        if (this.activeFlow === "current") {
            // Business Details
            const busName = document.getElementById("wizBusinessName")?.value ?? "";
            const gstin = document.getElementById("wizGstin")?.value ?? "";
            const compPhone = document.getElementById("wizCompanyPhone")?.value ?? "";
            const compEmail = document.getElementById("wizCompanyEmail")?.value ?? "";
            const odLimit = parseFloat(document.getElementById("wizOverdraftLimit")?.value || "0");

            html += '<div class="summary-card">' +
                '<h5>Corporate Company Profile</h5>' +
                '<div class="summary-grid">' +
                '<div class="summary-field">' +
                '<span>Company Name</span>' +
                '<strong>' + this.escapeHTML(busName) + '</strong>' +
                '</div>' +
                '<div class="summary-field">' +
                '<span>GSTIN Code</span>' +
                '<strong>' + this.escapeHTML(gstin) + '</strong>' +
                '</div>' +
                '<div class="summary-field">' +
                '<span>Corporate Phone</span>' +
                '<strong>' + this.escapeHTML(compPhone) + '</strong>' +
                '</div>' +
                '<div class="summary-field">' +
                '<span>Corporate Email</span>' +
                '<strong>' + this.escapeHTML(compEmail) + '</strong>' +
                '</div>' +
                '<div class="summary-field">' +
                '<span>Overdraft Limit</span>' +
                '<strong>₹' + odLimit.toLocaleString('en-IN', { minimumFractionDigits: 2 }) + '</strong>' +
                '</div>' +
                '</div>' +
                '</div>';

            // Partners summary
            const pFirsts = document.getElementsByName("partnerFirstName");
            const pLasts = document.getElementsByName("partnerLastName");
            if (pFirsts.length > 0) {
                html += '<div class="summary-card">' +
                    '<h5>Partner Signatories (' + pFirsts.length + ')</h5>' +
                    '<div class="summary-grid">';
                for (let i = 0; i < pFirsts.length; i++) {
                    html += '<div class="summary-field">' +
                        '<span>Partner #' + (i + 1) + '</span>' +
                        '<strong>' + this.escapeHTML(pFirsts.item(i).value) + ' ' + this.escapeHTML(pLasts.item(i).value) + '</strong>' +
                        '</div>';
                }
                html += '</div></div>';
            }
        } else {
            // Primary Holder
            const pFirst = document.getElementById("wizFirstName")?.value ?? "";
            const pLast = document.getElementById("wizLastName")?.value ?? "";
            const pEmail = document.getElementById("wizEmail")?.value ?? "";
            const pPhone = document.getElementById("wizPhoneNo")?.value ?? "";
            const pPan = document.getElementById("wizPanCard")?.value ?? "";
            const pAadhaar = document.getElementById("wizAadhaarCard")?.value ?? "";
            const pDob = document.getElementById("wizDob")?.value ?? "";

            let ageCategory = "";
            if (pDob) {
                const dobD = new Date(pDob);
                const today = new Date();
                let age = today.getFullYear() - dobD.getFullYear();
                const mDiff = today.getMonth() - dobD.getMonth();
                if (mDiff < 0 || (mDiff === 0 && today.getDate() < dobD.getDate())) {
                    age--;
                }
                ageCategory = age >= 18 ? "Major Account" : "Minor Account";
            }

            html += '<div class="summary-card">' +
                '<h5>Primary Holder Personal Details</h5>' +
                '<div class="summary-grid">' +
                '<div class="summary-field">' +
                '<span>Full Name</span>' +
                '<strong>' + this.escapeHTML(pFirst) + ' ' + this.escapeHTML(pLast) + '</strong>' +
                '</div>' +
                '<div class="summary-field">' +
                '<span>Email signature</span>' +
                '<strong>' + this.escapeHTML(pEmail) + '</strong>' +
                '</div>' +
                '<div class="summary-field">' +
                '<span>Phone signature</span>' +
                '<strong>' + this.escapeHTML(pPhone) + '</strong>' +
                '</div>' +
                '<div class="summary-field">' +
                '<span>PAN Card</span>' +
                '<strong>' + this.escapeHTML(pPan) + '</strong>' +
                '</div>' +
                '<div class="summary-field">' +
                '<span>Aadhaar Ident</span>' +
                '<strong>' + this.escapeHTML(pAadhaar) + '</strong>' +
                '</div>' +
                (ageCategory ?
                    '<div class="summary-field" style="color: var(--primary-500);">' +
                    '<span>Age Category</span>' +
                    '<strong>' + ageCategory + '</strong>' +
                    '</div>' : '') +
                '</div>' +
                '</div>';

            // Joint Holder
            if (this.activeFlow === "savings_joint") {
                const modeSelect = document.getElementById("wizJointCustomerMode");
                const mode = modeSelect ? modeSelect.value : "existing";
                let jointName = "";
                if (mode === "existing") {
                    const sel = document.getElementById("wizJointCustomerId");
                    jointName = sel ? sel.options[sel.selectedIndex].text : "";
                } else {
                    const jFirst = document.getElementById("wizJointFirstName")?.value ?? "";
                    const jLast = document.getElementById("wizJointLastName")?.value ?? "";
                    jointName = `${jFirst} ${jLast} (Brand New Profile)`;
                }

                html += '<div class="summary-card">' +
                    '<h5>Joint Holder Signatory Details</h5>' +
                    '<div class="summary-grid">' +
                    '<div class="summary-field">' +
                    '<span>Holding Signee</span>' +
                    '<strong>' + this.escapeHTML(jointName) + '</strong>' +
                    '</div>' +
                    '</div>' +
                    '</div>';
            }

            // Nominee Details
            const nomineeVal = document.getElementById("wizNomineeName");
            const nominee = nomineeVal ? nomineeVal.value.trim() : "";
            const limitVal = document.getElementById("wizDailyWithdrawalLimit");
            const limitNum = limitVal ? parseFloat(limitVal.value) : 50000.00;

            html += '<div class="summary-card">' +
                '<h5>Nominee configuration</h5>' +
                '<div class="summary-grid">' +
                '<div class="summary-field">' +
                '<span>Nominee Name</span>' +
                '<strong>' + (nominee ? this.escapeHTML(nominee) : "No Nominee Registered") + '</strong>' +
                '</div>' +
                '<div class="summary-field">' +
                '<span>Daily ATM Limit</span>' +
                '<strong>₹' + limitNum.toLocaleString('en-IN', { minimumFractionDigits: 2 }) + '</strong>' +
                '</div>' +
                '</div>' +
                '</div>';
        }

        // Section 3: preferences & credentials
        const hasAtmCheck = document.getElementById("wizHasAtmCard");
        const hasChequeCheck = document.getElementById("wizHasChequeBook");
        const hasAtm = hasAtmCheck ? hasAtmCheck.checked : false;
        const hasCheque = hasChequeCheck ? hasChequeCheck.checked : false;

        let services = [];
        if (hasAtm) services.push("ATM Debit Card");
        if (hasCheque) services.push("Cheque Book");
        if (this.activeFlow !== "current") services.push("Passbook (Default selected)");

        const usernameVal = document.getElementById("wizUsername");
        const pinVal = document.getElementById("wizPin");

        html += '<div class="summary-card">' +
            '<h5>Onboarding preferences & credentials</h5>' +
            '<div class="summary-grid">' +
            '<div class="summary-field">' +
            '<span>Services approved</span>' +
            '<strong>' + (services.join(", ") || "None") + '</strong>' +
            '</div>' +
            '<div class="summary-field">' +
            '<span>Login Username</span>' +
            '<strong>' + (usernameVal ? this.escapeHTML(usernameVal.value) : "") + '</strong>' +
            '</div>' +
            '<div class="summary-field" style="color: var(--accent-emerald);">' +
            '<span>Auto-Generated PIN</span>' +
            '<strong>' + (pinVal ? this.escapeHTML(pinVal.value) : "") + '</strong>' +
            '</div>' +
            '</div>' +
            '</div>';

        // Section 4: deposit
        const depositInput = document.getElementById("wizInitialDeposit");
        const deposit = depositInput ? parseFloat(depositInput.value) : 0;

        html += '<div class="summary-card" style="border-left: 4px solid var(--accent-emerald);">' +
            '<h5>Initial Funding Ledger</h5>' +
            '<div class="summary-grid">' +
            '<div class="summary-field">' +
            '<span>Initial Deposit Credit</span>' +
            '<strong style="color: var(--accent-emerald); font-size: 1.1rem;">₹' + deposit.toLocaleString('en-IN', { minimumFractionDigits: 2 }) + '</strong>' +
            '</div>' +
            '</div>' +
            '</div>';

        container.innerHTML = html;
    }

    // Apply 3D tilt effect to a card wrapper
    applyCardTiltEffect(wrapperId) {
        const wrapper = document.getElementById(wrapperId);
        if (!wrapper) return;

        wrapper.addEventListener('mousemove', (e) => {
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

        wrapper.addEventListener('mouseleave', () => {
            wrapper.style.transition = "transform 0.5s cubic-bezier(0.4, 0, 0.2, 1)";
            wrapper.style.transform = "perspective(1000px) rotateX(0deg) rotateY(0deg) scale3d(1, 1, 1)";
        });

        wrapper.addEventListener('mouseenter', () => {
            wrapper.style.transition = "none";
        });
    }

    // Show 3D card preview for ATM card option in preferences step
    showWizAtmCardPreview() {
        const wrapper = document.getElementById('wizAtmTiltWrapper');
        const card = document.getElementById('wizAtmPreviewCard');

        if (wrapper && card) {
            card.classList.remove('flipped');
            card.classList.add('interactive');
            wrapper.style.transform = "perspective(1000px) rotateX(0deg) rotateY(0deg) scale3d(1, 1, 1)";
            this.applyCardTiltEffect('wizAtmTiltWrapper');
        }
    }

    // Flip the wizard ATM card preview
    flipWizAtmCard() {
        const card = document.getElementById("wizAtmPreviewCard");
        if (card) {
            card.classList.toggle("flipped");
        }
    }

    // Flip generic 3D service card previews (cheque book, passbook)
    flipWizServiceCard(cardId) {
        const card = document.getElementById(cardId);
        if (card) {
            card.classList.toggle("flipped");
        }
    }

    // Sync wizard ATM card preview with control selections
    syncWizAtmCardPreview() {
        const card = document.getElementById('wizAtmPreviewCard');
        const typeSelect = document.getElementById('wizCardType');
        const providerSelect = document.getElementById('wizCardProvider');

        if (!card || !typeSelect || !providerSelect) return;

        const type = typeSelect.value;
        const provider = providerSelect.value;
        const hasAtmCheck = document.getElementById('wizHasAtmCard');
        const hasAtm = hasAtmCheck ? hasAtmCheck.checked : false;

        const providerLabel = document.getElementById('wizProviderLabel');
        if (providerLabel) providerLabel.innerText = provider.toUpperCase();

        // Set card background based on type
        card.className = "vgb-atm-card";
        if (type === 'credit') {
            card.classList.add('credit');
        } else {
            card.classList.add('debit');
        }

        let number = "4589 7321 6048 2190";
        const numberLabel = document.getElementById('wizNumberLabel');
        const holderLabel = document.getElementById('wizHolderLabel');
        if (numberLabel) numberLabel.innerText = number;
        if (holderLabel) holderLabel.innerText = hasAtm ? "NEW ACCOUNT" : "DEMO HOLDER";
    }

    // Mask/Unmask CVV on the back face securely without flipping card
    toggle3DCardCvv(event, element) {
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

    // Toggle selection by clicking ATM card
    toggleWizAtmSelection() {
        const checkbox = document.getElementById("wizHasAtmCard");
        if (checkbox) {
            checkbox.checked = !checkbox.checked;
            this.toggleCardOptionWiz();
        }
    }

    // Toggle selection by clicking Cheque card
    toggleWizChequeSelection() {
        const checkbox = document.getElementById("wizHasChequeBook");
        if (checkbox) {
            checkbox.checked = !checkbox.checked;
            this.toggleChequeOptionWiz();
        }
    }

    // Sync 3D Service Cards selection status visual styling (active vs inactive)
    sync3DCardSelection() {
        const hasAtmCheck = document.getElementById("wizHasAtmCard");
        if (!hasAtmCheck) return;
        const hasAtm = hasAtmCheck.checked;

        const atmCard = document.getElementById("wizAtmPreviewCard");
        if (atmCard) {
            if (hasAtm) {
                atmCard.classList.remove("inactive-card");
            } else {
                atmCard.classList.add("inactive-card");
            }
        }

        const hasChequeCheck = document.getElementById("wizHasChequeBook");
        if (!hasChequeCheck) return;
        const hasCheque = hasChequeCheck.checked;
        const chequeCard = document.getElementById("wizChequePreviewCard");
        if (chequeCard) {
            if (hasCheque) {
                chequeCard.classList.remove("inactive-card");
            } else {
                chequeCard.classList.add("inactive-card");
            }
        }
    }

    setupPreferencesObserver() {
        const prefsPane = document.getElementById("wizardStepPreferences");
        if (!prefsPane) return;

        const observer = new MutationObserver((mutations) => {
            mutations.forEach((mutation) => {
                if (mutation.type === "attributes" && mutation.attributeName === "class") {
                    const pane = mutation.target;
                    if (pane.id === "wizardStepPreferences" && pane.classList.contains("active")) {
                        // Show/Initialize ATM Card
                        setTimeout(this.showWizAtmCardPreview, 100);

                        // Initialize Cheque Card tilt and state
                        setTimeout(() => {
                            const chequeCard = document.getElementById("wizChequePreviewCard");
                            if (chequeCard) {
                                chequeCard.classList.remove("flipped");
                                chequeCard.classList.add("interactive");
                                chequeCard.style.transform = "perspective(1000px) rotateX(0deg) rotateY(0deg) scale3d(1, 1, 1)";
                                this.applyCardTiltEffect("wizChequePreviewCard");
                            }
                        }, 150);

                        // Initialize Passbook Card tilt and state
                        setTimeout(() => {
                            const pbCard = document.getElementById("wizPassbookPreviewCard");
                            if (pbCard) {
                                pbCard.classList.remove("flipped");
                                pbCard.classList.add("interactive");
                                pbCard.style.transform = "perspective(1000px) rotateX(0deg) rotateY(0deg) scale3d(1, 1, 1)";
                                this.applyCardTiltEffect("wizPassbookPreviewCard");
                            }
                        }, 200);

                        // Sync active/inactive card visual classes
                        this.sync3DCardSelection();
                    }
                }
            });
        });

        observer.observe(prefsPane, { attributes: true });
    }

    setupFormSubmitListeners() {
        // Client side validation on update form submit
        const editAccountForm = document.getElementById("editAccountForm");
        if (editAccountForm) {
            editAccountForm.addEventListener("submit", (e) => {
                const phoneInput = document.getElementById("editPhoneNo");
                const phone = phoneInput ? phoneInput.value.trim() : "";
                if (phone.length > 0 && (phone.length !== 10 || !/^\d+$/.test(phone))) {
                    alert("Primary Phone number must be exactly 10 digits.");
                    e.preventDefault();
                    return;
                }

                const jointPhoneInput = document.getElementById("editJointPhoneNo");
                const jointPhone = jointPhoneInput ? jointPhoneInput.value.trim() : "";
                const holdingTypeSelect = document.getElementById("editHoldingType");
                const holdingType = holdingTypeSelect ? holdingTypeSelect.value : "single";
                if (holdingType === "joint" && jointPhone.length > 0 && (jointPhone.length !== 10 || !/^\d+$/.test(jointPhone))) {
                    alert("Joint Phone number must be exactly 10 digits.");
                    e.preventDefault();
                    return;
                }

                const pinInput = document.getElementById("editPin");
                const pin = pinInput ? pinInput.value.trim() : "";
                if (pin.length > 0 && (pin.length !== 4 || !/^\d+$/.test(pin))) {
                    alert("Secure PIN must be exactly 4 numeric digits.");
                    e.preventDefault();
                    return;
                }

                const pwdInput = document.getElementById("editPassword");
                const password = pwdInput ? pwdInput.value : "";
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
        }

        // Intercept final submission to verify funding
        const createAccountForm = document.getElementById("createAccountForm");
        if (createAccountForm) {
            createAccountForm.addEventListener("submit", (e) => {
                const depositInput = document.getElementById("wizInitialDeposit");
                if (!depositInput) return;
                const deposit = parseFloat(depositInput.value);
                const minVal = this.activeFlow === "current" ? 5000 : 1000;

                if (isNaN(deposit) || deposit < minVal) {
                    alert(`Onboarding deposit payment declines: Deposit must be a minimum of ₹${minVal.toLocaleString('en-IN', { minimumFractionDigits: 2 })}.`);
                    e.preventDefault();
                }
            });
        }
    }
}


// Global exports for compatibility with inline event handlers in JSP files
const vgbAdminManager = new VGBAdminAccountManager();

document.addEventListener("DOMContentLoaded", () => {
    // Only initialize if we are on the admin accounts page or card pages where VGB elements are present
    const searchInput = document.getElementById("searchInput");
    const accountsTable = document.getElementById("accountsTable");
    const createAccountModal = document.getElementById("createAccountModal");
    const editAccountForm = document.getElementById("editAccountForm");

    if (searchInput || accountsTable || createAccountModal || editAccountForm) {
        vgbAdminManager.init();
    }
});

// Map essential methods to window
window.escapeHTML = vgbAdminManager.escapeHTML;
window.filterAccountsTable = vgbAdminManager.filterAccountsTable;
window.closeStatementModal = vgbAdminManager.closeStatementModal;
window.triggerSoftCloseAccount = vgbAdminManager.triggerSoftCloseAccount;
window.triggerHardDeleteAccount = vgbAdminManager.triggerHardDeleteAccount;
window.switchModalTab = vgbAdminManager.switchModalTab;
window.openEditAccountModal = vgbAdminManager.openEditAccountModal;
window.toggleJointTabOnHoldingChange = vgbAdminManager.toggleJointTabOnHoldingChange;
window.closeEditAccountModal = vgbAdminManager.closeEditAccountModal;
window.openCreateAccountModal = vgbAdminManager.openCreateAccountModal;
window.closeCreateAccountModal = vgbAdminManager.closeCreateAccountModal;
window.toggleJointModeFields = vgbAdminManager.toggleJointModeFields;
window.toggleCardOptionWiz = vgbAdminManager.toggleCardOptionWiz;
window.toggleChequeOptionWiz = vgbAdminManager.toggleChequeOptionWiz;
window.toggleClassificationFlowSelection = vgbAdminManager.toggleClassificationFlowSelection;
window.navigateWizardStep = vgbAdminManager.navigateWizardStep;
window.addPartnerCard = vgbAdminManager.addPartnerCard;
window.removePartnerCard = vgbAdminManager.removePartnerCard;
window.flipWizAtmCard = vgbAdminManager.flipWizAtmCard;
window.flipWizServiceCard = vgbAdminManager.flipWizServiceCard;
window.toggle3DCardCvv = vgbAdminManager.toggle3DCardCvv;
window.toggleWizAtmSelection = vgbAdminManager.toggleWizAtmSelection;
window.toggleWizChequeSelection = vgbAdminManager.toggleWizChequeSelection;
