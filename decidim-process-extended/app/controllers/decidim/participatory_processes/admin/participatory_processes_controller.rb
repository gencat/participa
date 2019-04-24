# frozen_string_literal: true

module Decidim
  module ParticipatoryProcesses
    module Admin
      # Controller that allows managing participatory processes.
      #
      class ParticipatoryProcessesController < Decidim::ParticipatoryProcesses::Admin::ApplicationController
        include Decidim::Admin::ParticipatorySpaceAdminContext
        participatory_space_admin_layout only: [:edit]
        include Decidim::Paginable

        helper ProcessGroupsForSelectHelper

        helper_method :current_participatory_process, :current_participatory_space, :query

        layout "decidim/admin/participatory_processes"

        def index
          enforce_permission_to :read, :process_list
          @participatory_processes = collection
        end

        def new
          enforce_permission_to :create, :process
          @form = form(ParticipatoryProcessForm).instance
        end

        def create
          enforce_permission_to :create, :process
          @form = form(ParticipatoryProcessForm).from_params(params)

          CreateParticipatoryProcess.call(@form) do
            on(:ok) do |participatory_process|
              flash[:notice] = I18n.t("participatory_processes.create.success", scope: "decidim.admin")
              redirect_to participatory_process_steps_path(participatory_process)
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("participatory_processes.create.error", scope: "decidim.admin")
              render :new
            end
          end
        end

        def edit
          enforce_permission_to :update, :process, process: current_participatory_process
          @form = form(ParticipatoryProcessForm).from_model(current_participatory_process)
          render layout: "decidim/admin/participatory_process"
        end

        def update
          enforce_permission_to :update, :process, process: current_participatory_process
          @form = form(ParticipatoryProcessForm).from_params(
            participatory_process_params,
            process_id: current_participatory_process.id
          )

          UpdateParticipatoryProcess.call(current_participatory_process, @form) do
            on(:ok) do |participatory_process|

              # add "default" hero / banner image code
              if participatory_process.hero_image.url.blank?
                add_default_image_hero (participatory_process.id)
                add_default_image_banner (participatory_process.id)
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

        def copy
          enforce_permission_to :create, Decidim::ParticipatoryProcess
        end

        private

        def process_group
          @process_group ||= ParticipatoryProcessGroup.find_by(id: params[:group_id])
        end

        def participatory_processes
          @participatory_processes ||= Rectify::Query.merge(
            ParticipatoryProcessesWithUserRole.for(current_user),
            ParticipatoryProcessesByGroup.for(process_group)
          )
        end

        def query
          @query ||= participatory_processes.ransack(params[:q])
        end

        def collection
          @collection ||= paginate(query.result)
        end

        def current_participatory_process
          @current_participatory_process ||= collection.where(slug: params[:slug]).or(
            collection.where(id: params[:slug])
          ).first
        end

        alias current_participatory_space current_participatory_process

        def ability_context
          super.merge(current_participatory_space: current_participatory_process)
        end

        def participatory_process_params
          {
            id: params[:id],
            hero_image: current_participatory_process.hero_image,
            banner_image: current_participatory_process.banner_image
          }.merge(params[:participatory_process].to_unsafe_h)
        end

        def add_default_image_hero(id)

          base_name = "image"

          # setting path variables to get number of files inside
          default_images_path = File.join Rails.root, 'decidim-process-extended', 'app', 'assets', 'images', 'default_images'

          # getting number of files (hero image folder)
          number_of_files_hero = Dir.glob(File.join(default_images_path, '**', '*')).select { |file| File.file?(file) }.count

          # we need to add 1 to those numbers, to do the if
          # number_of_files_hero   += 1

          last_image = Decidim::ParticipatoryProcess.where("hero_image like ?", "%" + base_name +"%").last

          if last_image.nil?
            last_image = base_name + "01.png"
          else
            last_image = last_image[:hero_image]
            image_number = last_image[(base_name.length)..(base_name.length + 1)]

            image_number = image_number.to_i
            if image_number >= number_of_files_hero
              image_number = 1
            else
              image_number += 1
            end

            image_number = image_number.to_s.rjust(2, '0')
            last_image = base_name + image_number + ".png"
          end

          ActiveRecord::Base.connection.execute("update decidim_participatory_processes SET hero_image = '" + last_image + "' where id = " + id.to_s)

          path = File.join Rails.root, 'public', 'uploads', 'decidim', 'participatory_process', 'hero_image', id.to_s

          image_path = File.join Rails.root, 'decidim-process-extended', 'app', 'assets', 'images', 'default_images', last_image

          FileUtils.mkdir_p(path) unless File.exist?(path)

          if File.exist?(path)
            FileUtils.cp image_path, path, :verbose => true
          else

          end

        end

        def add_default_image_banner(id)

          base_name = "image"

          # setting path variables to get number of files inside
          default_images_path_b = File.join Rails.root, 'decidim-process-extended', 'app', 'assets', 'images', 'default_images_b'

          # getting number of files (banner image folder)
          number_of_files_banner = Dir.glob(File.join(default_images_path_b, '**', '*')).select { |file| File.file?(file) }.count

          # we need to add 1 to those numbers, to do the if
          # number_of_files_banner += 1

          last_image = Decidim::ParticipatoryProcess.where("banner_image like ?", "%" + base_name +"%").last

          # if image is null (nil), we assign the first one to put in database
          if last_image.nil?
            last_image = base_name + "01.png"
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

            image_number = image_number.to_s.rjust(2, '0')
            last_image = base_name + image_number + ".png"
          end

          ActiveRecord::Base.connection.execute("update decidim_participatory_processes SET banner_image = '" + last_image + "' where id = " + id.to_s)

          path_banner = File.join Rails.root, 'public', 'uploads', 'decidim', 'participatory_process', 'banner_image', id.to_s

          image_path_banner = File.join Rails.root, 'decidim-process-extended', 'app', 'assets', 'images', 'default_images_b', last_image

          FileUtils.mkdir_p(path_banner) unless File.exist?(path_banner)

          if File.exist?(path_banner)
            FileUtils.cp image_path_banner, path_banner, :verbose => true
          else

          end

        end
      end
    end
  end
end
