// Form validation for login
document.addEventListener('DOMContentLoaded', function() {

    // Login form validation
    const loginForm = document.getElementById('loginForm');
    if (loginForm) {
        loginForm.addEventListener('submit', function(e) {
            const username = document.getElementById('username').value.trim();
            const password = document.getElementById('password').value.trim();

            if (!username || !password) {
                e.preventDefault();
                showAlert('Please fill in all fields', 'error');
                return false;
            }

            if (username.length < 3) {
                e.preventDefault();
                showAlert('Username must be at least 3 characters', 'error');
                return false;
            }
        });
    }

    // Register form validation
    const registerForm = document.getElementById('registerForm');
    if (registerForm) {
        registerForm.addEventListener('submit', function(e) {
            const fullName = document.getElementById('fullName').value.trim();
            const username = document.getElementById('username').value.trim();
            const email = document.getElementById('email').value.trim();
            const password = document.getElementById('password').value.trim();
            const confirmPassword = document.getElementById('confirmPassword').value.trim();

            // Check if all fields are filled
            if (!fullName || !username || !email || !password || !confirmPassword) {
                e.preventDefault();
                showAlert('Please fill in all fields', 'error');
                return false;
            }

            // Validate username length
            if (username.length < 3) {
                e.preventDefault();
                showAlert('Username must be at least 3 characters', 'error');
                return false;
            }

            // Validate email format
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                e.preventDefault();
                showAlert('Please enter a valid email address', 'error');
                return false;
            }

            // Validate password length
            if (password.length < 6) {
                e.preventDefault();
                showAlert('Password must be at least 6 characters', 'error');
                return false;
            }

            // Check if passwords match
            if (password !== confirmPassword) {
                e.preventDefault();
                showAlert('Passwords do not match', 'error');
                return false;
            }

            // Password strength indicator
            const strength = checkPasswordStrength(password);
            if (strength === 'weak') {
                const proceed = confirm('Your password is weak. Do you want to continue?');
                if (!proceed) {
                    e.preventDefault();
                    return false;
                }
            }
        });

        // Real-time password match checking
        const passwordInput = document.getElementById('password');
        const confirmPasswordInput = document.getElementById('confirmPassword');

        if (confirmPasswordInput) {
            confirmPasswordInput.addEventListener('input', function() {
                if (passwordInput.value !== confirmPasswordInput.value) {
                    confirmPasswordInput.style.borderColor = '#ff4757';
                } else {
                    confirmPasswordInput.style.borderColor = '#2ed573';
                }
            });
        }
    }

    // Auto-hide alerts after 5 seconds
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        setTimeout(() => {
            alert.style.opacity = '0';
            alert.style.transition = 'opacity 0.5s ease';
            setTimeout(() => {
                alert.style.display = 'none';
            }, 500);
        }, 5000);
    });
});

// Function to show custom alerts
function showAlert(message, type) {
    const existingAlerts = document.querySelectorAll('.alert');
    existingAlerts.forEach(alert => alert.remove());

    const alertDiv = document.createElement('div');
    alertDiv.className = `alert alert-${type}`;
    alertDiv.textContent = message;

    const formWrapper = document.querySelector('.form-wrapper');
    const formHeader = document.querySelector('.form-header');

    if (formWrapper && formHeader) {
        formHeader.insertAdjacentElement('afterend', alertDiv);

        setTimeout(() => {
            alertDiv.style.opacity = '0';
            alertDiv.style.transition = 'opacity 0.5s ease';
            setTimeout(() => {
                alertDiv.remove();
            }, 500);
        }, 5000);
    }
}

// Check password strength
function checkPasswordStrength(password) {
    let strength = 0;

    if (password.length >= 8) strength++;
    if (password.match(/[a-z]/)) strength++;
    if (password.match(/[A-Z]/)) strength++;
    if (password.match(/[0-9]/)) strength++;
    if (password.match(/[^a-zA-Z0-9]/)) strength++;

    if (strength <= 2) return 'weak';
    if (strength <= 4) return 'medium';
    return 'strong';
}

// Add input focus animations
const inputs = document.querySelectorAll('input');
inputs.forEach(input => {
    input.addEventListener('focus', function() {
        this.parentElement.classList.add('focused');
    });

    input.addEventListener('blur', function() {
        this.parentElement.classList.remove('focused');
    });
});

// Prevent form resubmission on page refresh
if (window.history.replaceState) {
    window.history.replaceState(null, null, window.location.href);
}