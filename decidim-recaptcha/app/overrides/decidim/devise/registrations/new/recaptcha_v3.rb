# frozen_string_literal: true

# Replace Decidim's invisible_captcha with Google reCAPTCHA v3 on the sign up form.
Deface::Override.new(virtual_path: "decidim/devise/registrations/new",
                     name: "replace_invisible_captcha_with_recaptcha_v3",
                     replace: "erb[loud]:contains('invisible_captcha')",
                     original: "a9b54598e526eb0d4fd6bdbb7585ca902c41e56f",
                     text: "<%= recaptcha_v3(action: 'registration') %>")
