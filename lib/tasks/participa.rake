# frozen_string_literal: true

# Next tasks are necessary to be executed on production
# because there are some records in the database that don't have
# a component or participatory space related
# This may be due to an incorrect import of the old system or to a bad delete
# of the records.
# At the request of the GENCAT, it has been decided not to delete these records.
# If these tasks don't run before the deployment of 0.15 version,
# there may be problems with some migrations, and they will fail.
namespace :participa do
  # Components ------
  #
  # Find the Organization.
  # Find or Create an unpublished participatory process
  # Takes all the components that don't have a participatory space related.
  # Assign the created participatory process to the components
  # without participatory space .
  desc 'Fix Orphan Component records'
  task fix_orphan_component_records: [:environment] do
    organization = Decidim::Organization.first
    participatory_space = Decidim::ParticipatoryProcess.find_or_create_by(
      title: { 'ca' => 'Procés registres orfes' },
      slug: 'proces-registres-orfes',
      subtitle: { 'ca' => 'soluciona registres orfes' },
      short_description: { 'ca' => 'soluciona registres orfes' },
      description: { 'ca' => 'soluciona registres orfes' },
      organization: organization
    )

    orphan_components = Decidim::Component.where(participatory_space: nil)

    orphan_components.each do |component|
      puts "----- Upgrade #{component.manifest_name} ---#{component.id}"
      component.update(participatory_space: participatory_space)
    end
  end

  # Proposals ------
  #
  # Find the Organization.
  # Find or Create an unpublished participatory process
  # Find or Create a proposal component related to the previous participatory process
  # Takes all the proposals that don't have a component related.
  # Assign the created component to the proposals
  # without component
  desc 'Fix Orphan proposals records'
  task fix_orphan_proposal_records: [:environment] do
    organization = Decidim::Organization.first
    participatory_space = Decidim::ParticipatoryProcess.find_or_create_by(
      title: { 'ca' => 'Procés registres orfes' },
      slug: 'proces-registres-orfes',
      subtitle: { 'ca' => 'soluciona registres orfes' },
      short_description: { 'ca' => 'soluciona registres orfes' },
      description: { 'ca' => 'soluciona registres orfes' },
      organization: organization
    )
    proposal_component = Decidim::Component.find_or_create_by(
      name: { 'ca' => 'Procés registres orfes' },
      manifest_name: 'proposals',
      participatory_space: participatory_space
    )
    orphan_proposals = Decidim::Proposals::Proposal.where(component: nil)

    orphan_proposals.each do |proposal|
      puts "--------------- Upgrade #{proposal.title} -- #{proposal.id}"
      proposal.assign_attributes(component: proposal_component)
      proposal.save(validate: false)
    end
  end

  # Meetings ------
  #
  # Find the Organization.
  # Find or Create an unpublished participatory process
  # Find or Create a meeting component related to the previous participatory process
  # Takes all the meetings that don't have a component related.
  # Assign the created component to the meetings
  # without component
  desc 'Fix Orphan meetings records'
  task fix_orphan_meetings_records: [:environment] do
    organization = Decidim::Organization.first
    participatory_space = Decidim::ParticipatoryProcess.find_or_create_by(
      title: { 'ca' => 'Procés registres orfes' },
      slug: 'proces-registres-orfes',
      subtitle: { 'ca' => 'soluciona registres orfes' },
      short_description: { 'ca' => 'soluciona registres orfes' },
      description: { 'ca' => 'soluciona registres orfes' },
      organization: organization
    )
    meeting_component = Decidim::Component.find_or_create_by(
      name: { 'ca' => 'Procés registres orfes' },
      manifest_name: 'meetings',
      participatory_space: participatory_space
    )
    orphan_meetings = Decidim::Meetings::Meeting.where(component: nil)

    orphan_meetings.each do |meeting|
      puts "--------------- Upgrade #{meeting.title} -- #{meeting.id}"
      meeting.assign_attributes(component: meeting_component)
      meeting.save(validate: false)
    end
  end
end
