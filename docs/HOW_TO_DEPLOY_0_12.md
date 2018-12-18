# KEEP IN MIND WHEN DEPLOYING 0.12

Take a look to the Changelog https://github.com/decidim/decidim/blob/0.12-stable/CHANGELOG.md to specific actions. Instead of run the "Upgrade notes" on Changelog 0.12, execute next queries to prevent some crashes"

---

### ADD MEETINGS TO SEARCH (only meetings with ParticipatorySpace)
```
component_ids_without_space = Decidim::Component.where(manifest_name: "meetings").find_all{|c| c.participatory_space.blank? }.pluck(:id)

Decidim::Meetings::Meeting.where.not(component: component_ids_without_space).find_each(&:add_to_index_as_search_resource)
```

---

### ADD PROPOSALS TO SEARCH (only proposals with ParticipatorySpace and Component)
```
component_ids_without_space = Decidim::Component.where(manifest_name: "proposals").find_all{|c| c.participatory_space.blank? }.pluck(:id)

proposal_component_ids_that_not_exist = Decidim::Proposals::Proposal.all.find_all{|p| p.component.blank? }.pluck(:decidim_component_id).uniq

Decidim::Proposals::Proposal.where.not(component: component_ids_without_space + proposal_component_ids_that_not_exist).find_each(&:add_to_index_as_search_resource)
```
---
