# Decorators and Overrides

This document describes all Decidim extensions present in this project, organized by functionality.

---

## Decorators

Decorators use the `class_eval` pattern within a `self.decorate` module method to extend Decidim classes at load time. They are located in `app/decorators/` and auto-loaded via a glob in `config/application.rb`.

---

### Organization and Participatory Spaces

#### `decidim/organization_decorator.rb`
Overrides the `users_with_any_role` association in `Decidim::Organization` to include users with roles in participatory processes and assemblies, not just those with direct roles in the organization.

#### `decidim/participatory_space_context_decorator.rb`
Adds the `current_user_can_visit_space?` method to the `ParticipatorySpaceContext` concern. Determines whether the current user can access a private space by checking if they are an admin, have any role in the space, or are an invited private user.

#### `decidim/participatory_processes/permissions_decorator.rb`
Adds the `can_view_private_space?` method to `Decidim::ParticipatoryProcesses::Permissions`. Allows access to the public view of private processes if the user is an admin, in the space's user list, or is an invited private user.

---

### Attachments in static pages

#### `decidim/static_pages_decorator.rb`
Includes the `HasAttachments` concern in the `Decidim::StaticPage` model, enabling support for file attachments (documents and images) on static pages.

#### `decidim/admin/static_pages_form_decorator.rb`
Adds the attachment attributes to `Decidim::Admin::StaticPageForm`: `attachment` and `attachments` (with `add_attachments`, via `attachments_attribute :attachments`), including upload validations. Since Decidim 0.31 the attribute must be called `attachments`, because `Decidim::MultipleAttachmentsMethods` reads `form.attachments` and `form.add_attachments` (until 0.30 it was `documents`).

#### `decidim/admin/create_static_page_decorator.rb` and `decidim/admin/update_static_page_decorator.rb`
Extend the `CreateStaticPage` and `UpdateStaticPage` commands with `Decidim::MultipleAttachmentsMethods` to validate, create and clean up (`attachment_cleanup!`) the attachments when saving a page.

#### `decidim/admin/static_pages_controller_decorator.rb`
Exposes `tab_panel_items` as a helper in the admin static pages controller to display document and photo tabs in the admin view.

#### `decidim/pages_controller_decorator.rb`
Extends the public pages controller to include `AttachmentsHelper` and expose `tab_panel_items` as a helper, enabling attachment tabs in the public page view.

#### `decidim/attachments_helper_decorator.rb`
Overrides `attachments_tab_panel_items` in `AttachmentsHelper` to generate two separate tabs: one for documents (using the `decidim/documents_panel` cell) and one for photos (using the `decidim/images_panel` cell).

---

### Asset URLs (Storage)

#### `decidim/asset_router/storage_decorator.rb`
Overrides the private `blob_url` method in `Decidim::AssetRouter::Storage`. When the project uses `resolve_model_to_route: :rails_storage_proxy`, it forces the use of `rails_blob_url` (permanent URLs like `/rails/active_storage/blobs/proxy/…`) instead of `blob.url()` (5-minute temporary disk URLs). Uses `only_path: true` to avoid host errors in contexts without requests.

---

### Proposal Imports

Allow to import Proposals with a Meeting as author.

#### `decidim/proposals/import/proposal_creator_decorator.rb`
Extends `ProposalCreator` (used when importing proposals from CSV/Excel) to:
- Assign a **meeting as a proposal location** if the data has `meeting_url`.
- Assign an **external author** (person outside the platform) if the data has `external_author/name`.
- Add the organization as the author in the default case, like Decidim 0.31 does (until 0.30 it was the current user).
- Add `finish_without_notif!` to create the proposal without sending individual notifications (used in bulk imports).

#### `decidim/proposals/import/proposal_answer_creator_decorator.rb`
Adds `finish_without_notif!` to `ProposalAnswerCreator` to answer proposals during bulk import without triggering individual notifications.

#### `decidim/admin/import/importer_decorator.rb`
Overrides the `import!` method of the general importer so that instead of notifying each item individually, it groups items and sends **one bulk notification** (mailer) to all followers of the participatory space:
- `ProposalsMailer.notify_massive_import` for proposal imports.
- `ProposalsAnswersMailer.notify_massive_import` for answer imports.

---

### Proposal Co-authorship

Allow to import Proposals with a Meeting as author.

#### `decidim/coauthorable_decorator.rb`
Adds two methods to `Coauthorable` objects (using `prepend` instead of `class_eval`):
- `add_external_author(name, organization)`: creates or retrieves an `ExternalAuthor` and adds them as a coauthor.
- `add_location(meeting_url)`: resolves a meeting ID from its URL and adds it as a coauthor (for proposals presented in a meeting).

---

### Proposal Export

Allow to import Proposals with a Meeting as author.

#### `lib/decidim/proposals/proposal_serializer_decorator.rb`
Extends `ProposalSerializer` to include the `authors_names` field (array with author names) in exported proposal data, useful for CSV/Excel exports.

---

### Meetings

#### `decidim/meetings/meeting_card_metadata_cell_decorator.rb`
Extends `MeetingCardMetadataCell` with `prepend` to add the **participatory process name** as metadata in the meeting card, but only when viewed from a different context than the space it belongs to (for example, when listing all meetings from a different space). Until Decidim 0.30 it was in `app/overrides/decidim/meetings/meeting_card_metadata_cell_extension.rb`.

---

### Newsletters

#### `decidim/admin/selective_newsletter_participatory_space_type_form_decorator.rb`
Adds the `process_group_id` attribute to the selective newsletter participatory space type form. When mapping the model, if the space is `participatory_processes`, it uses the ID of the regulations group configured in `Rails.application.config.regulation`.

#### `decidim/admin/selective_newsletter_form_decorator.rb`
Overrides `map_model` of the selective newsletter form to add an extra item at the beginning of the spaces list: processes from the group configured in `Rails.application.config.process` (allows filtering by process group when sending newsletters).

#### `decidim/admin/newsletters_helper_decorator.rb`
Extends the admin newsletters panel helper with methods for:
- `participatory_space_types_form_object`: renders the form block for each space type.
- `participatory_space_title`: overridden to use `label_text_for` for custom space type labels (respects process group names).
- `select_tag_participatory_spaces`: generates the `<select>` of available spaces with label passed to the cell.
- `label_text_for`: displays the process group name as a label if the space has `process_group_id`.
- `spaces_for_select`: filters available spaces by process group.
- `filter_spaces_by_process_group`: filters participatory processes by their group when `manifest_name == :participatory_processes`.

---

## Overrides

Overrides in `app/overrides/` change Decidim views with Deface. Ruby extensions of Decidim classes go to `app/decorators/` (see above), not here.

**Write view overrides as `.html.erb.deface` files, not as `.rb` files.** The file must be in a folder that matches the view virtual path (for example `app/overrides/decidim/admin/static_pages/_form/attachments.html.erb.deface` changes `decidim/admin/static_pages/_form`), the override name is the file name, and the Deface options go in a first HTML comment:

```erb
<!-- insert_after "div.row.column:has(erb[loud]:contains('number_field :weight'))"
     original 'f262dbb35b9efa006a99115ff87df970da3c5bb0'
-->
<%# Description of the override (it is not rendered) %>
<div>...</div>
```

Since Rails 7.1, Deface no longer tells Zeitwerk to ignore `app/overrides` (it checks `config.autoloader`, which was removed). Zeitwerk then expects every `.rb` file there to define a constant, and the app does not boot in the test environment (`Zeitwerk::NameError: expected file .../app/overrides/... to define constant ...`). `.deface` files are not Ruby, so Zeitwerk ignores them.

---

#### `decidim/devise/passwords/edit/user_password_errors.html.erb.deface`
Deface override on the `decidim/devise/passwords/edit` view. Inserts a paragraph with resource validation errors (`resource.errors`) at the end of the `div.form__wrapper` to display error messages when changing password.

#### `decidim/proposals/admin/proposals/_proposals-thead/attachments_th.html.erb.deface` and `decidim/proposals/admin/proposals/_proposal-tr/attachments_td.html.erb.deface`
When the component allows attachments, they add an "Attachments" column to the proposals admin index, right after the "Evaluators" one: the header (sortable with `sort_link`, using the scopes in `decidim/proposals/proposal_decorator.rb`) and the cell with the number of attachments of each proposal (with `data-label`, like the rest of cells). Since Decidim 0.31 the evaluators cell is `td.evaluators-count` (it was `td.valuators-count`).

#### `decidim/meetings/admin/meetings/_form/google_maps_url.html.erb.deface`
Inserts the `google_maps_url` field before the online meeting URL field of the admin meeting form, visible only for in-person and hybrid meetings. See the "Google Maps URL for meetings" section in the README.

#### `decidim/admin/static_pages/_form/attachments.html.erb.deface`
Inserts the attachments field (`form.attachment :attachments`) after the "weight" field of the admin static page form, except for the terms of service page. The attributes are handled by `decidim/admin/static_pages_form_decorator.rb` and the create/update command decorators. It replaces the full copy of the form that was used until Decidim 0.30.

---

### Overrides in internal modules

#### `decidim-recaptcha/app/overrides/decidim/devise/registrations/new/recaptcha_v3.html.erb.deface`
Replaces `invisible_captcha` with `recaptcha_v3(action: "registration")` in the sign up form. It replaces the full copy of the view that was used until Decidim 0.30.

#### `decidim-process-extended/app/overrides/decidim/participatory_processes/admin/participatory_processes/_form/participa_metadata_fields.html.erb.deface`
Inserts the Participa fields (`promoting_unit`, `facilitators`, `cost`, `email`, `has_summary_record`) in the metadata section of the admin process form, after `developer_group`. It replaces the full copy of the form that was used until Decidim 0.30.

#### `decidim-process-extended/app/overrides/layouts/decidim/admin/participatory_process/proposal_component_alert.html.erb.deface`
Shows an alert in the admin of the "Normativa" processes when the proposals component is not published.

#### `decidim-top_comments/app/overrides/decidim/{proposals,debates}/.../show.html.erb.deface`
Insert the "most voted comments" block in the proposal and debate show pages, after `content_for :item_footer`.

#### `decidim-home/app/overrides/layouts/decidim/{header,footer}/_main/*.html.erb.deface`
Gencat navbar, language chooser and FEDER footer.

---

### About the `original` option

Every Deface override sets `original`, so Deface logs `Deface: [ERROR] The original source for '<name>' has changed` when Decidim changes that part of the view, and the override has to be reviewed. The value is **not** the SHA1 of the whole file, but the SHA1 of the HTML matched by the selector, without whitespace. To get it, from a Rails console:

```ruby
src = File.read(File.join(Gem.loaded_specs["decidim-admin"].full_gem_path, "app/views/decidim/admin/static_pages/_form.html.erb"))
match = Deface::Parser.convert(src).css("div.row.column:has(erb[loud]:contains('number_field :weight'))")
Digest::SHA1.hexdigest(match.to_s.gsub(/\s/, ""))
```
