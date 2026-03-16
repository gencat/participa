class BackfillHasSummaryRecordDefault < ActiveRecord::Migration[7.0]
  def change
    execute <<-SQL.squish
      UPDATE decidim_participatory_processes
      SET has_summary_record = false
      WHERE has_summary_record IS NULL
    SQL

    change_column_null :decidim_participatory_processes, :has_summary_record, false, false
  end
end
