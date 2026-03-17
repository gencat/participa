class BackfillHasSummaryRecordDefault < ActiveRecord::Migration[7.0]
  def change
    change_column_default :decidim_participatory_processes, :has_summary_record, from: nil, to: false
    change_column_null :decidim_participatory_processes, :has_summary_record, false, false
  end
end
