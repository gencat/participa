# frozen_string_literal: true

Decidim::ParticipatoryProcesses::Admin::ParticipatoryProcessesController.class_eval do
  def update
    enforce_permission_to :update, :process, process: current_participatory_process
    @form = form(Decidim::ParticipatoryProcesses::Admin::ParticipatoryProcessForm).from_params(
      participatory_process_params,
      process_id: current_participatory_process.id
    )

    Decidim::ParticipatoryProcesses::Admin::UpdateParticipatoryProcess.call(current_participatory_process, @form) do
      on(:ok) do |participatory_process|
        # add "default" hero / banner image code
        if participatory_process.attached_uploader(:hero_image).path.blank?
          add_default_image_hero participatory_process.id
          add_default_image_banner participatory_process.id
        end
        flash[:notice] = I18n.t("participatory_processes.update.success", scope: "decidim.admin")
        redirect_to edit_participatory_process_path(participatory_process)
      end

      on(:invalid) do
        flash.now[:alert] = I18n.t("participatory_processes.update.error", scope: "decidim.admin")
        render :edit, layout: "decidim/admin/participatory_process"
      end
    end
  end

  private

  def process_extended_root
    @process_extended_root||= begin
      all_railties= Rails.application.migration_railties
      engine= all_railties.find { |railtie| railtie.railtie_name == "decidim_process_extended" }
      engine.root
    end
  end

  def add_default_image_hero(id)
    base_name = "image"

    default_images_path= process_extended_root.join("config", "default_images", "hero")

    # getting number of files (hero image folder)
    number_of_files_hero = Dir.glob(File.join(default_images_path, "**", "*")).select { |file| File.file?(file) }.count

    last_image = Decidim::ParticipatoryProcess.where("hero_image like ?", "%#{base_name}%").last

    if last_image.nil?
      last_image = "#{base_name}01.png"
    else
      last_image = last_image[:hero_image]
      image_number = last_image[(base_name.length)..(base_name.length + 1)]

      image_number = image_number.to_i
      if image_number >= number_of_files_hero
        image_number = 1
      else
        image_number += 1
      end

      image_number = image_number.to_s.rjust(2, "0")
      last_image = "#{base_name}#{image_number}.png"
    end

    ActiveRecord::Base.connection.execute("update decidim_participatory_processes SET hero_image = '#{last_image}' where id = #{id}")

    Decidim::ParticipatoryProcess.find(id).hero_image.attach(
      io: File.open(File.join(default_images_path, last_image)),
      filename: last_image,
      content_type: "image/png"
    )
  end

  def add_default_image_banner(id)
    base_name = "image"

    default_images_path_b = process_extended_root.join("config", "default_images", "banner")

    # getting number of files (banner image folder)
    number_of_files_banner = Dir.glob(File.join(default_images_path_b, "**", "*")).select { |file| File.file?(file) }.count

    last_image = Decidim::ParticipatoryProcess.where("banner_image like ?", "%#{base_name}%").last

    # if image is null (nil), we assign the first one to put in database
    if last_image.nil?
      last_image = "#{base_name}01_b.png"
    else
      # if not, we take the number of the image and we add 1 to it
      last_image = last_image[:banner_image]
      image_number = last_image[(base_name.length)..(base_name.length + 1)]

      image_number = image_number.to_i
      if image_number >= number_of_files_banner
        image_number = 1
      else
        image_number += 1
      end

      image_number = image_number.to_s.rjust(2, "0")
      last_image = "#{base_name}#{image_number}_b.png"
    end

    ActiveRecord::Base.connection.execute("update decidim_participatory_processes SET banner_image = '#{last_image}' where id = #{id}")

    Decidim::ParticipatoryProcess.find(id).banner_image.attach(
      io: File.open(File.join(default_images_path_b, last_image)),
      filename: last_image,
      content_type: "image/png"
    )
  end
end
