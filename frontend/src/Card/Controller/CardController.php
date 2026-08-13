<?php

declare(strict_types=1);

namespace App\Card\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class CardController extends AbstractController
{

    #[Route('/card', name: 'card', options: ['expose' => true])]
    public function __invoke(): Response
    {
        return $this->render('card/card.html.twig', []);
    }

}
