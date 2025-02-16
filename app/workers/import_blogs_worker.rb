class ImportBlogsWorker
    include Sidekiq::Worker
    
    sidekiq_options queue: :default, retry: 3
  
    def perform(file_path, user_id)
      ImportBlogsService.new(file_path, user_id).call
      File.delete(file_path) if File.exist?(file_path) # Cleanup after processing
    end
  end
  