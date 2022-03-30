import click
from memetext.memetext import MemeText


base_image = "images/wreck_overview.png"


def produce(name, ext):
    save_path = f"c:/images/{name}.{ext}"

    MemeText(
        image_path=base_image,
        top=name,
        bottom=None,
        save_path=save_path,
        fontsize=120,
        border=3
    )


@click.command()
@click.option(
    "--name",
    "name"
)
def main(name):
    click.echo("main")
    produce(name, "jpg")
    produce(name, "png")


if __name__ == '__main__':
    main()
