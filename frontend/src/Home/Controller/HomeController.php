<?php

declare(strict_types=1);

namespace App\Home\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class HomeController extends AbstractController
{

    #[Route('/', name: 'home', options: ['expose' => true])]
    public function __invoke(): Response
    {
        return $this->render('home/home.html.twig', []);
    }

}
