namespace :participa do
  desc "Fix Orphan Component records"
  task :fix_orphan_component_records => [ :environment ] do
    organization =  Decidim::Organization.first
    participatory_space = Decidim::ParticipatoryProcess.find_or_create_by(
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
      puts "----- Upgrade #{component.manifest_name} ---#{component.id}"
      component.update(participatory_space: participatory_space)
    end
  end

  task :fix_orphan_proposal_records => [ :environment ] do
    organization =  Decidim::Organization.first
    participatory_space = Decidim::ParticipatoryProcess.find_or_create_by(
                            title: {"ca"=> "Procés registres orfes"},
                            slug: "proces-registres-orfes",
                            subtitle: {"ca"=> "soluciona registres orfes"},
                            short_description: {"ca"=> "soluciona registres orfes"},
                            description: {"ca"=> "soluciona registres orfes"},
                            organization: organization,
                          )
    proposal_component = Decidim::Component.find_or_create_by(
                            name: {"ca"=> "Procés registres orfes"},
                            manifest_name: "proposals",
                            participatory_space: participatory_space
                          )
    orphan_proposals = Decidim::Proposals::Proposal.all.find_all{|p| p.component.blank? }

    orphan_proposals.each do |proposal|
      next unless proposal.component.blank?
      puts "--------------- Upgrade #{proposal.title} -- #{proposal.id}"
      proposal.assign_attributes(component: proposal_component)
      proposal.save(validate: false)
    end
  end

end
