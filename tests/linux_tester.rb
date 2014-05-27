helpers do
  def set_tester_inputs
    clouds = ::VirtualMonkey::Toolbox::get_available_clouds
    servers.each do |s|
      cloud_name = clouds.find { |c| c["cloud_id"].to_i == s.cloud_id.to_i }["name"]

      if cloud_name =~ /ec2|vsphere|vscale/
        datacenter = "env:DATACENTER"
      else
        datacenter = "text:false"
      end

      if cloud_name =~ /vsphere|vscale/
        public_key_expected = "text:true"
      else
        public_key_expected = "text:false"
      end

      # TBD vscale permutations

      s.set_inputs({
        "rightlink_test/datacenter" => datacenter,
        "DATACENTER"                => "text:#{ipv6}"
      })
    end
  end
end

before do
  stop_all
  # Use launch set instead of relaunch_all, which launches things serially in --one-deploy is set
  set_tester_inputs
  launch_set
end

test_case "default" do
  wait_for_all("operational")
end

after do
  stop_all
end
