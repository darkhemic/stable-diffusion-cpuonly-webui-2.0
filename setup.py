from setuptools import setup, find_packages

setup(
    name='sd-cpuonly-webui-2.0',
    version='0.0.1',
    description='',
    packages=find_packages(),
    install_requires=[
        'torch',
        'numpy',
        'tqdm',
    ],
)
