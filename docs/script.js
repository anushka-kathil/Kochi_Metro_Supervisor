// ===================================
// Kochi Metro Supervisor - Download Website
// JavaScript Functionality
// ===================================

document.addEventListener('DOMContentLoaded', () => {
    initNavbarScroll();
    initSmoothScroll();
    initAnimations();
    fetchLatestRelease();
});

// Navbar scroll effect
function initNavbarScroll() {
    const navbar = document.querySelector('.navbar');
    let lastScroll = 0;
    
    window.addEventListener('scroll', () => {
        const currentScroll = window.pageYOffset;
        
        if (currentScroll > 100) {
            navbar.style.background = 'rgba(10, 10, 15, 0.95)';
            navbar.style.boxShadow = '0 4px 30px rgba(0, 0, 0, 0.3)';
        } else {
            navbar.style.background = 'rgba(10, 10, 15, 0.8)';
            navbar.style.boxShadow = 'none';
        }
        
        lastScroll = currentScroll;
    });
}

// Smooth scroll for anchor links
function initSmoothScroll() {
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
}

// Intersection Observer for animations
function initAnimations() {
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);
    
    // Observe feature cards
    document.querySelectorAll('.feature-card').forEach((card, index) => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(30px)';
        card.style.transition = `all 0.6s cubic-bezier(0.4, 0, 0.2, 1) ${index * 0.1}s`;
        observer.observe(card);
    });
    
    // Observe screenshot cards
    document.querySelectorAll('.screenshot-card').forEach((card, index) => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(30px)';
        card.style.transition = `all 0.6s cubic-bezier(0.4, 0, 0.2, 1) ${index * 0.15}s`;
        observer.observe(card);
    });
    
    // Add animate-in class styles
    const style = document.createElement('style');
    style.textContent = `
        .animate-in {
            opacity: 1 !important;
            transform: translateY(0) !important;
        }
    `;
    document.head.appendChild(style);
}

// Fetch latest release info from GitHub
async function fetchLatestRelease() {
    const versionEl = document.getElementById('app-version');
    const sizeEl = document.getElementById('app-size');
    const downloadBtn = document.getElementById('download-btn');
    
    try {
        const response = await fetch('https://api.github.com/repos/anushka-kathil/Kochi_Metro_Supervisor/releases/latest');
        
        if (!response.ok) {
            console.log('No releases found yet, using default values');
            return;
        }
        
        const release = await response.json();
        
        // Update version
        if (versionEl && release.tag_name) {
            versionEl.textContent = release.tag_name.replace('v', '');
        }
        
        // Find APK asset and update size and download link
        if (release.assets && release.assets.length > 0) {
            const apkAsset = release.assets.find(asset => 
                asset.name.endsWith('.apk')
            );
            
            if (apkAsset) {
                // Update size
                if (sizeEl) {
                    const sizeMB = (apkAsset.size / (1024 * 1024)).toFixed(1);
                    sizeEl.textContent = `${sizeMB} MB`;
                }
                
                // Update download link
                if (downloadBtn) {
                    downloadBtn.href = apkAsset.browser_download_url;
                }
            }
        }
        
    } catch (error) {
        console.log('Could not fetch release info:', error.message);
        // Keep default values
    }
}

// Add loading animation to download button
const downloadBtn = document.querySelector('.btn-download');
if (downloadBtn) {
    downloadBtn.addEventListener('click', function() {
        this.innerHTML = `
            <svg class="spin" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="12" cy="12" r="10" stroke-dasharray="60" stroke-dashoffset="20"/>
            </svg>
            Downloading...
        `;
        
        // Reset after 3 seconds
        setTimeout(() => {
            this.innerHTML = `
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
                    <polyline points="7 10 12 15 17 10"/>
                    <line x1="12" y1="15" x2="12" y2="3"/>
                </svg>
                Download APK
            `;
        }, 3000);
    });
}

// Add spin animation for loading
const spinStyle = document.createElement('style');
spinStyle.textContent = `
    @keyframes spin {
        from { transform: rotate(0deg); }
        to { transform: rotate(360deg); }
    }
    .spin {
        animation: spin 1s linear infinite;
    }
`;
document.head.appendChild(spinStyle);
