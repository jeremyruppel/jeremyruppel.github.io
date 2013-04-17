module LinkedinHelper

  ##
  # Represents a linkedin profile. Accepts the profile uri and parses
  # the HTML, offering a much nicer API for extracting key information.
  class Profile
    def initialize( uri )
      require 'open-uri'
      @doc = Nokogiri::HTML( open( uri ) )
    end

    ##
    #
    def []( *selector )
      @doc.css *selector
    end

    ##
    #
    def full_name
      self[ '#name' ].text.strip
    end

    ##
    #
    def headline
      self[ '.headline-title' ].text.strip
    end

    ##
    #
    def summary
      self[ '#profile-summary .summary' ].text.strip
    end

    ##
    #
    def jobs
      self[ '#profile-experience .position' ].map { |node| Job.new( node ) }
    end

    ##
    #
    def skills
      self[ '#profile-skills .competency' ].map( &:text )
    end

    ##
    #
    def education
      self[ '#profile-education .education'].map { |node| Education.new( node ) }
    end
  end

  module Duration

    ##
    #
    def duration
      "%s - %s" % [ started_on, ended_on ]
    end

    ##
    #
    def started_on
      self[ '.period .dtstart' ].text
    end

    ##
    #
    def ended_on
      self[ '.period .dtend', '.period .dtstamp' ].text
    end
  end

  ##
  # Represents an entry in the "Experience" section of a profile.
  class Job
    include Duration

    def initialize( node )
      @node = node
    end

    ##
    #
    def []( *selector )
      @node.at_css *selector
    end

    ##
    #
    def title
      self[ 'h3 .title' ].text
    end

    ##
    #
    def company_name
      self[ '.company-profile-public' ].text
    end

    ##
    #
    def company_url
      'http://linkedin.com' + self[ '.company-profile-public' ][ 'href' ]
    end

    ##
    #
    def company_details
      self[ '.organization-details' ].text
    end

    ##
    #
    def location
      self[ '.period .location' ].text
    end

    ##
    #
    def description
      self[ '.description' ].try( :text ) || 'No Description'
    end
  end

  class Education
    include Duration

    def initialize( node )
      @node = node
    end

    ##
    #
    def []( *selector )
      @node.at_css *selector
    end

    ##
    #
    def summary
      self[ '.summary' ].text
    end

    ##
    #
    def details
      self[ '.details-education' ].text
    end
  end

  ##
  #
  def linkedin
    @linkedin ||= Profile.new linkedin_uri
  end

  def resume_pdf_path
    "/#{linkedin.full_name}.pdf"
  end

  def linkedin_uri
    File.join Middleman.locate_root, 'tmp/jeremyruppel.html'
  end
end
