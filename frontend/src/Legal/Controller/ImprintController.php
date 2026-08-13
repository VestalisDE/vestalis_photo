<?php

declare(strict_types=1);

namespace App\Legal\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class ImprintController extends AbstractController
{

    #[Route('/impressum', name: 'legal/imprint', options: ['expose' => true])]
    public function __invoke(): Response
    {
        return $this->render('legal/imprint.html.twig', []);
    }

}
