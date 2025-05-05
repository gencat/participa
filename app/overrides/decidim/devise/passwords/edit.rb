# frozen_string_literal: true

# decidim/account/_password_fields is rendered from many places,
# override only for change password
Deface::Override.new(virtual_path: "decidim/devise/passwords/edit",
                     name: "user_password_errors",
                     insert_bottom: "div.form__wrapper",
                     original: "c950081d4664b1b248062a481a9cbc39d49a0fda",
                     text: <<~EOHTML)
                       <% if defined?(resource) && resource&.errors&.any? %>
                         <p class="form-error is-visible" role="alert"><%= resource.errors.full_messages.join(', ') %></p>
                       <% end %>
                     EOHTML
