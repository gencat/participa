class MoveDecidimTypesToParticipatoryProcessTypes < ActiveRecord::Migration[6.1]
  def change
    DecidimType.find_each do |type|
      Decidim::ParticipatoryProcessType.create!(title: {ca: type.name["ca"], es: type.name["es"], oc: type.name["oc"]}, decidim_organization_id: type.decidim_organization_id)
    end
  end
end
