namespace :monit do
  
  namespace :centos do

    desc <<-DESC
    Install monit.
    
    monit_port: Monit port. Defaults to 2812.
    
      set :monit_port, 2812

    monit_password: Monit password. Defaults to password prompt.
    
      set :monit_password, Proc.new { Capistrano::CLI.ui.ask('Monit admin password (to set): ') })
      
    DESC
    task :install do
      
      # Settings
      fetch_or_default(:monit_port, 2812)
      fetch_or_default(:monit_password, 
        Proc.new { Capistrano::CLI.ui.ask('Monit admin password (to set): ') })
        
      # Install dependencies
      yum.install([ "flex", "byacc" ])
        
      # Build options
      monit_options = {
        :url => "http://www.tildeslash.com/monit/dist/monit-4.10.1.tar.gz"
      }

      # Build
      script.make_install("monit", monit_options)

      # Install initscript
      put template.load("monit/monit.initd.centos.erb"), "/tmp/monit.initd"
      sudo "install -o root /tmp/monit.initd /etc/init.d/monit && rm -f /tmp/monit.initd"

      # Install monitrc
      put template.load("monit/monitrc.erb"), "/tmp/monitrc"
      sudo "mkdir -p /etc/monit && install -o root -m 700 /tmp/monitrc /etc/monitrc && rm -f /tmp/monitrc"

      # Patch initab
      script.sh("monit/patch_inittab.sh")

      # Build cert
      put template.load("monit/monit.cnf"), "/tmp/monit.cnf"
      script.sh("monit/cert.sh")
    end

  end
  
end