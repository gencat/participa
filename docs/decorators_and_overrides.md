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

### Attachments in Pages

#### `decidim/pages/page_decorator.rb`
Includes the `HasAttachments` concern in the `Decidim::Pages::Page` model, enabling support for file attachments (documents and images) on static pages.

#### `decidim/pages/admin/page_form_decorator.rb`
Adds attributes to the page edit form (`PageForm`) for uploading attachments: `attachment`, `documents` (multiple), and `photos` (multiple), including corresponding upload validations.

#### `decidim/pages/admin/update_page_decorator.rb`
Extends the `UpdatePage` command to process and persist attachments and photo gallery when updating a page. Includes cleanup of previous attachments and validation before saving.

#### `decidim/pages/admin/pages_controller_decorator.rb`
Exposes `tab_panel_items` as a helper in the admin pages controller to display document and photo tabs in the admin view.

#### `decidim/pages/application_controller_decorator.rb`
Extends the public pages controller to include `AttachmentsHelper` and expose `tab_panel_items` as a helper, enabling attachment tabs in the public page view.

#### `decidim/attachments_helper_decorator.rb`
Overrides `attachments_tab_panel_items` in `AttachmentsHelper` to generate two separate tabs: one for documents (using the `decidim/documents_panel` cell) and one for photos (using the `decidim/images_panel` cell).

---

### Asset URLs (Storage)

#### `decidim/asset_router/storage_decorator.rb`
Overrides the private `blob_url` method in `Decidim::AssetRouter::Storage`. When the project uses `resolve_model_to_route: :rails_storage_proxy`, it forces the use of `rails_blob_url` (permanent URLs like `/rails/active_storage/blobs/proxy/…`) instead of `blob.url()` (5-minute temporary disk URLs). Uses `only_path: true` to avoid host errors in contexts without requests.

---

### Proposal Imports

#### `decidim/proposals/import/proposal_creator_decorator.rb`
Extends `ProposalCreator` (used when importing proposals from CSV/Excel) to:
- Assign a **meeting as a proposal location** if the data has `meeting_url`.
- Assign an **external author** (person outside the platform) if the data has `external_author/name`.
- Add the current user as a coauthor in the default case.
- Add `finish_without_notif!` to create the proposal without sending individual notifications (used in bulk imports).

#### `decidim/proposals/import/proposal_answer_creator_decorator.rb`
Adds `finish_without_notif!` to `ProposalAnswerCreator` to answer proposals during bulk import without triggering individual notifications.

#### `decidim/admin/import/importer_decorator.rb`
Overrides the `import!` method of the general importer so that instead of notifying each item individually, it groups items and sends **one bulk notification** (mailer) to all followers of the participatory space:
- `ProposalsMailer.notify_massive_import` for proposal imports.
- `ProposalsAnswersMailer.notify_massive_import` for answer imports.

---

### Proposal Co-authorship

#### `decidim/coauthorable_decorator.rb`
Adds two methods to `Coauthorable` objects (using `prepend` instead of `class_eval`):
- `add_external_author(name, organization)`: creates or retrieves an `ExternalAuthor` and adds them as a coauthor.
- `add_location(meeting_url)`: resolves a meeting ID from its URL and adds it as a coauthor (for proposals presented in a meeting).

---

### Proposal Export

#### `lib/decidim/proposals/proposal_serializer_decorator.rb`
Extends `ProposalSerializer` to include the `authors_names` field (array with author names) in exported proposal data, useful for CSV/Excel exports.

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

## Cells (View Components)

#### `app/cells/decidim/admin/multi_select_picker/show.erb`
Overrides the multi-select picker cell template to render a `label_tag` when a label is provided in the context, properly associating it with the select element via `for` attribute.

---

## Overrides

Overrides in `app/overrides/` extend Decidim behavior either with `prepend` (for Ruby) or with `Deface::Override` (for ERB views).

---

#### `decidim/meetings/meeting_card_metadata_cell_extension.rb`
Extends `MeetingCardMetadataCell` with `prepend` to add the **participatory process name** as metadata in the meeting card, but only when viewed from a different context than the space it belongs to (for example, when listing all meetings from a different space).

#### `decidim/devise/passwords/edit.rb`
Deface override on the `decidim/devise/passwords/edit` view. Inserts a paragraph with resource validation errors (`resource.errors`) at the end of the `div.form__wrapper` to display error messages when changing password.
