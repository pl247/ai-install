#!/bin/bash
echo "Running commands as a root user..."

# Create software directories
sudo mkdir /ai
sudo mkdir /ai/software

# Get NVIDIA GPU Drivers as well as CUDA
echo "==================Get NVIDIA GPU Drivers as well as CUDA=================="
# 12.1 that does not work
#sudo wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.0-1_all.deb -P /ai/software
#sudo dpkg -i /ai/software/cuda-keyring_1.0-1_all.deb
#sudo apt-get update
#sudo apt-get -y install cuda

# 11.7 for 20.04
#sudo wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin -P /ai/software
#sudo mv /ai/software/cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
#sudo wget https://developer.download.nvidia.com/compute/cuda/11.7.0/local_installers/cuda-repo-ubuntu2004-11-7-local_11.7.0-515.43.04-1_amd64.deb -P /ai/software
#sudo dpkg -i /ai/software/cuda-repo-ubuntu2004-11-7-local_11.7.0-515.43.04-1_amd64.deb
#sudo cp /var/cuda-repo-ubuntu2004-11-7-local/cuda-*-keyring.gpg /usr/share/keyrings/
#sudo apt-get update
#sudo apt-get install cuda-11-7

# 11.7 for 22.04
sudo wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin -P /ai/software
sudo mv /ai/software/cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
sudo wget https://developer.download.nvidia.com/compute/cuda/11.7.0/local_installers/cuda-repo-ubuntu2204-11-7-local_11.7.0-515.43.04-1_amd64.deb -P /ai/software
sudo dpkg -i /ai/software/cuda-repo-ubuntu2204-11-7-local_11.7.0-515.43.04-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2204-11-7-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get updatesudo 
apt-get -y install cuda

# Get AI Monitor
echo "==================Get AI Monitor=========================================="
sudo git -C /ai clone https://github.com/pl247/ai-monitor
sudo chmod a+x /ai/ai-monitor

# Install Miniconda
echo "==================Get AMiniconda=========================================="
sudo wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.12.0-Linux-x86_64.sh -P /ai/software
sudo chmod -v +x /ai/software/Miniconda3-py39_4.12.0-Linux-x86_64.sh
sudo /ai/software/Miniconda3-py39_4.12.0-Linux-x86_64.sh -b -p /ai/miniconda

echo "End of running commands as root."

# Modify PATH
echo "==================Updating PATH=========================================="
eval "$(/ai/miniconda/bin/conda shell.bash hook)"
echo 'export PATH="/ai/miniconda/bin:/ai/miniconda/condabin:/usr/local/cuda/bin:$PATH"' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"' >> ~/.bashrc
source .bashrc


# Create new conda environment
echo "==================Create New Conda Environment============================"
conda init bash
conda create -n textgen python=3.10.9
conda activate textgen

# Install pytorch
echo "==================Installing Pytorch======================================="
pip3 install torch torchvision torchaudio

# Install web UI
echo "==================Installing WebUI=========================================="
git -C /home/ubuntu clone https://github.com/oobabooga/text-generation-webui
pip install -r /home/ubuntu/text-generation-webui/requirements.txt

# Install first LLM model
echo "==================Installing LLM Models=========================================="
cd /home/ubuntu/text-generation-webui
python3 download-model.py facebook/opt-350m
python3 download-model.py TheBloke/vicuna-7B-1.1-HF
#python3 download-model.py TheBloke/vicuna-13B-1.1-HF
#python3 download-model.py TheBloke/Wizard-Vicuna-30B-Uncensored-fp16

# Clean up tasks
echo "==================For changes to take effect, close and re-open current shell ========================="