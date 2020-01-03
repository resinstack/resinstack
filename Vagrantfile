Vagrant.configure("2") do |config|
  (1..3).each do |c|
    config.vm.define ("consul"+c.to_s) do |node|
      node.vm.box = "consul"
      node.vm.provider "libvirt" do |domain|
        domain.mgmt_attach false
      end
      node.vm.synced_folder ".", "/vagrant", disabled: true
    end
  end
end
