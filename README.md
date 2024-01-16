# Finder/Main/
Finder is a repo system based on [FYC-Rewrite V2]() that is made for installing or just doing really whatever you want with it. It's made to be edited and open-source down to the repo system itself.

## Installing
To install Finder open a terminal and type the following command listed below note that [Windows](https://www.microsoft.com/en-us/windows?r=1) is not tested.
```bash
git clone https://github.com/HttpAnimation/Finder.git
```

## Running
Open the **index.html** in the Finder folder if you see nothing show up you may need to allow Crocs everywhere.


## Adding a repo
To add a repo open the Finder folder with the terminal and **cd** over to wherever it's downloaded the default will be **/home/$user/home** it might be different so keep that in mind but once they run one of the following command **[nano](https://www.nano-editor.org/)** is gonna be installed for almost every distro and [macOS](https://www.apple.com/macos) and **[kate](https://kate-editor.org/)** is gonna be included on most systems with [KDE Plasma](https://kde.org/plasma-desktop/) installed you can also open the file manually if you don't have one of the following IDEs installed.

```
kate Configs/Replers/Repo.json
```
```bash
kate Configs/Replers/Repo.json
```
Once you have the file opened add a **,** at the end of your last repo URL for an example it may look like the following listed below.
```json
........com/repo.json",
```
Add a new line under the **,** and add **""** to that line and you should get something like this.
```
........com/repo.json",
"Gffg://100%ARealURL.json"
```
If you add another repo make sure to add the **,** again it just tells [JSON](https://www.json.org/json-en.html) that there is a new repo am planning on making a GUI for managing repos without no code editing but for now this is the way.


## Streaming

If you wish to stream your FYC page, you can choose one of the following methods:

1) Fork the repository
2) Host a network site

Each method has its pros and cons.

### Streaming/Forking - Information

Forking the repository is useful when you either cannot use a PC for running a lightweight server or cannot use Linux/macOS. However, keep in mind that everyone can see your site when you fork the repository, including GitHub. Ensure your site complies with [GitHub's TOS](https://docs.github.com/en/pages/getting-started-with-github-pages/about-github-pages) to avoid any issues.

### Streaming/Hosting - Information

Hosting is the best way to have an FYC site, but it has some downsides. No one outside your network can see your site, so avoid sharing your IP and port on platforms like Discord. Hosting requires a PC running Linux (recommended: [Ubuntu Server](https://ubuntu.com/download/server) or [Debian 12](https://www.debian.org/)). macOS can be used, but it may have some limitations. Notably, Windows or WSL will not work for hosting.

### Streaming/Forking - Running

Follow these steps to run a live fork of FYC using GitHub:

1) Install Finder using the provided command.
2) Change the directory to the Finder folder:
   ```bash
   cd Finder
   ```
3) Download a new README file to replace the old one:
   ```bash
   rm README.md && wget https://raw.githubusercontent.com/HttpAnimation/FYC-Rewrite-V2/main/Git-Hold/README.md
   ```
4) Create a new repository on [GitHub](https://github.com/new) and make a branch called gh-pages.
5) Upload the files to the gh-pages branch via GitHub's website.
6) Go to the Deployments section and access your website using the provided URL.

### Streaming/Hosting - Running

Follow these steps to run a live site using your local hardware:

5) Run the website, and the IP address and port will be displayed (public IPs) **MAKE SURE YOU ARE NOT IN SUDO**.
    ```bash
    ./Server.sh
    ```
6) you may run into issues saying you don't have permission if so allow the script to do stuff by running the following command listed below
    ```bash
    chmod +x Server.sh
    ```
