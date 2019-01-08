OmniAuth.config.logger= Rails.logger

Devise.setup do |config|
  config.omniauth :saml,
    idp_cert_fingerprint: 'E7:6B:5E:8E:6E:1E:28:C4:7C:8A:3B:46:2D:D0:41:37:CA:5C:6E:1E',
    idp_sso_target_url: 'https://samltest.id/idp/profile/SAML2/Redirect/SSO',
    strategy_class: OmniAuth::Strategies::SAML,
    issuer: '_4a3c2bc5-1fc8-4a91-a3e5-8d236ead71da',
    attribute_statements: {
      email: ['urn:oid:0.9.2342.19200300.100.1.3', 'mail'],
      name: ['urn:oid:2.16.840.1.113730.3.1.241', 'displayName'],
      nickname: ['uid', 'urn:oid:0.9.2342.19200300.100.1.1'],
      first_name: ['urn:oid:2.5.4.42', 'givenName'],
      last_name: ['urn:oid:2.5.4.4', 'sn'],
    }
end

Decidim::User.omniauth_providers << :saml
