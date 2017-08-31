require 'net/ftp'
require 'active_support/all'

module VMS
  
  class PrintSpooler

    # Destination folder on FTP server.
    FTP_DESTINATION = "/Users/vcms/Desktop/VCMS/AutoPrint/Auto/"

    # Printer definitions.
    PRINTERS = {
      :lp =>  { :human_name =>  "Dummy Printer",
                :color      =>  :lc },
      :ox =>  { :human_name =>  "Office Xerox",
                :color      =>  :oc },
      :oc =>  { :human_name =>  "Office Xerox" },
      :ph =>  { :human_name =>  "Production Dell" },
    }

    # Publicly accessible attribute readers.
    attr_reader :connected

    def initialize(options = {})

      # Read FTP server properties from environment variables.
      @ftp_host = ENV["VMS_PRINT_SPOOLER_FTP_SERVER"]
      @ftp_user = ENV["VMS_PRINT_SPOOLER_FTP_USERNAME"]
      @ftp_password = ENV["VMS_PRINT_SPOOLER_FTP_PASSWORD"]

      # Establish FTP connection.
      begin
        @ftp = Net::FTP.new @ftp_host
        @ftp.login @ftp_user, @ftp_password
        ObjectSpace.define_finalizer self, proc { @ftp.quit }
        @connected = true
      rescue
        @connected = false
      end

      # Store options.
      @printer = options[:printer] || PrinterChooser.choose
      @color = options[:color] || false

      # Unset connected flag if printer object doesn't exist.
      @connected = false if PRINTERS[@printer].nil?
      if @connected
        if @color && PRINTERS[@printer][:color]
          @printer = PRINTERS[@printer][:color]
          @connected = false if PRINTERS[@printer].nil?
        end
      end

    end

    def print_files(files, options = {})

      # Stop if not connected.
      return unless @connected

      # Set landscape orientation if necessary.
      landscape = options[:landscape] || false

      # If single path passed in, force to array.
      files = Array.wrap files

      # Upload files to FTP server.
      files.each do |f|
        pn = Pathname.new f
        if pn.file?
          parts = []
          parts << FTP_DESTINATION
          parts << "__#{@printer.to_s.upcase}"
          parts << "_L" if landscape
          parts << "__"
          parts << pn.basename.to_s.gsub(/\s+/, "_")
          @ftp.putbinaryfile f, parts.join
        end
      end

    end

  end
  
end