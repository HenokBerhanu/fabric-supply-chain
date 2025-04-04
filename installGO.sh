# 1. Remove the old version
sudo rm -rf /usr/local/go

sudo apt remove golang-go
sudo apt purge golang-go
sudo rm -rf /usr/bin/go /usr/lib/go /usr/local/go

# 2. Download Go 1.21.6
wget https://go.dev/dl/go1.21.6.linux-amd64.tar.gz

# 3. Extract to /usr/local
sudo tar -C /usr/local -xzf go1.21.6.linux-amd64.tar.gz

# 4. Update PATH
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc

# 5. Edit your ~/.bashrc
source ~/.bashrc

# Add this line at the end
export PATH=$PATH:/usr/local/go/bin

# Save and reload:
source ~/.bashrc

# 5. Verify installation
go version
