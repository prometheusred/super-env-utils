# Use the official Micromamba image to copy the necessary files
FROM mambaorg/micromamba:1.5.7 as micromamba

# Start from the TensorFlow Jupyter GPU image
FROM tensorflow/tensorflow:2.10.1-gpu-jupyter

# USER root

# Set the environment variables for Micromamba as provided in the example
ENV MAMBA_ROOT_PREFIX=/opt/micromamba
ENV MAMBA_EXE=/bin/micromamba
ENV MAMBA_USER=tensorflow
ENV MAMBA_USER_ID=1000
ENV MAMBA_USER_GID=1000

# Copy Micromamba binary and necessary initialization scripts
COPY --from=micromamba "$MAMBA_EXE" "$MAMBA_EXE"
COPY --from=micromamba /usr/local/bin/_activate_current_env.sh /usr/local/bin/
COPY --from=micromamba /usr/local/bin/_dockerfile_shell.sh /usr/local/bin/
COPY --from=micromamba /usr/local/bin/_entrypoint.sh /usr/local/bin/
COPY --from=micromamba /usr/local/bin/_dockerfile_initialize_user_accounts.sh /usr/local/bin/
COPY --from=micromamba /usr/local/bin/_dockerfile_setup_root_prefix.sh /usr/local/bin/

# Initialize user accounts and setup Micromamba root prefix
RUN /usr/local/bin/_dockerfile_initialize_user_accounts.sh && \
    /usr/local/bin/_dockerfile_setup_root_prefix.sh

# Switch to the non-root user if required
# USER $MAMBA_USER

# Set the shell to use Micromamba's initialization
SHELL ["/usr/local/bin/_dockerfile_shell.sh"]

# Create and configure the 'overcooked' environment
RUN micromamba create -y -p $MAMBA_ROOT_PREFIX/envs/overcooked python=3.7 git pip -c conda-forge && \
    micromamba clean --all --yes

# Clone and set up the Overcooked_AI project
WORKDIR /usr/src/app
RUN git clone https://github.com/HumanCompatibleAI/overcooked_ai.git && \
    cd overcooked_ai && \
    micromamba run -n overcooked pip install -e '.[harl]' && \
    micromamba clean --all --yes

# Expose the port for Jupyter Notebook
EXPOSE 8888

# Configure the container's entrypoint and default command
ENTRYPOINT ["/usr/local/bin/_entrypoint.sh"]
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--allow-root", "--no-browser", "--NotebookApp.token=''", "--NotebookApp.password=''"]
