from diffusers import DiffusionPipeline

pipe = DiffusionPipeline.from_pretrained("stabilityai/stable-diffusion-2-1-base")
pipe = pipe.to("mps")
pipe.enable_attention_slicing()

_ = pipe("Hello World.", num_inference_steps=1)
