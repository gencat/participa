# frozen_string_literal: true

namespace :tmp do
  task sortition: :environment do
    sortition= Decidim::StratifiedSortitions::StratifiedSortition.first
    service = Decidim::StratifiedSortitions::FairSortitionService.new(sortition)
    portfolio_result = service.generate_portfolio
    puts portfolio_result
    final_result = service.sample_from_portfolio(verification_seed: SecureRandom.hex(64))
    puts final_result.selected_participants
  end
end
