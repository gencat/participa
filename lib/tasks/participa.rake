namespace :participa do
  desc "Fix Orphan Component records"
  task :fix_orphan_component_records do
    organization =  Decidim::Organization.first
    participatory_space = Decidim::ParticipatoryProcess.create(
                            title: {"ca"=> "Procés registres orfes"},
                            slug: "proces-registres-orfes",
                            subtitle: {"ca"=> "soluciona registres orfes"},
                            short_description: {"ca"=> "soluciona registres orfes"},
                            description: {"ca"=> "soluciona registres orfes"},
                            organization: organization,
                          )

    orphan_components = Decidim::Component.all.find_all{|c| c.participatory_space.blank? }

    orphan_components.each do |component|
      next unless component.participatory_space.blank?
      component.update(participatory_space: participatory_space)
    end
  end

end
